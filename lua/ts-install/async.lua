--- @class ts-install.async
local M = {}

-- Use max 32-bit signed int value to avoid overflow on 32-bit systems.
-- Do not use `math.huge` as it is not interpreted as a positive integer on all
-- platforms.
local MAX_TIMEOUT = 2 ^ 31 - 1

--- @param ... any
--- @return {[integer]: any, n: integer}
local function pack_len(...)
  return { n = select('#', ...), ... }
end

--- like unpack() but use the length set by F.pack_len if present
--- @param t? { [integer]: any, n?: integer }
--- @param first? integer
--- @return any...
local function unpack_len(t, first)
  if t then
    return unpack(t, first or 1, t.n or table.maxn(t))
  end
end

--- @return_cast obj function
local function is_callable(obj)
  return vim.is_callable(obj)
end

--- Create a function that runs a function when it is garbage collected.
--- @generic F : function
--- @param f F
--- @param gc fun()
--- @return F
local function gc_fun(f, gc)
  local proxy = newproxy(true)
  local proxy_mt = getmetatable(proxy)
  proxy_mt.__gc = gc
  proxy_mt.__call = function(_, ...)
    return f(...)
  end

  return proxy
end

--- Weak table to keep track of running tasks
--- @type table<thread,ts-install.async.Task<any>?>
local threads = setmetatable({}, { __mode = 'k' })

--- @return ts-install.async.Task<any>?
local function running()
  local task = threads[coroutine.running()]
  if task and not task:completed() then
    return task
  end
end

--- Internal marker used to identify that a yielded value is an asynchronous yielding.
local yield_marker = {}
local resume_marker = {}

local resume_error = 'Unexpected coroutine.resume()'
local yield_error = 'Unexpected coroutine.yield()'

--- @generic T
--- @param marker string
--- @param err? any
--- @param ... T...
--- @return T...
local function check_yield(marker, err, ...)
  if marker ~= resume_marker then
    local task = assert(running(), 'Not in async context')
    vim.schedule(function()
      task:_resume(resume_error)
    end)
    -- Return an error to the caller. This will also leave the task in a dead
    -- and unfinshed state
    error(resume_error, 0)
  elseif err then
    error(err, 0)
  end
  return ...
end

--- @class ts-install.async.Closable
--- @field close fun(self, callback?: fun())

--- @param obj any
--- @return boolean
--- @return_cast obj ts-install.async.Closable
local function is_closable(obj)
  local ty = type(obj)
  return (ty == 'table' or ty == 'userdata') and vim.is_callable(obj.close)
end

--- Tasks are used to run coroutines in event loops. If a coroutine needs to
--- wait on the event loop, the Task suspends the execution of the coroutine and
--- waits for event loop to restart it.
---
--- Use the [ts-install.async.run()] to create Tasks.
---
--- To cancel a running Task use the `close()` method. Calling it will cause the
--- Task to throw a "closed" error in the wrapped coroutine.
---
--- Note a Task can be waited on via more than one waiter.
---
--- @class ts-install.async.Task<R>: ts-install.async.Closable
--- @field package _thread thread
--- @field package _future ts-install.async.Future<R>
--- @field package _closing boolean
---
--- Maintain children as an array to preserve closure order.
--- @field package _children table<integer, ts-install.async.Task<any>?>
---
--- Pointer to last child in children
--- @field package _children_idx integer
---
--- Tasks can await other async functions (task of callback functions)
--- when we are waiting on a child, we store the handle to it here so we can
--- cancel it.
--- @field package _awaiting? ts-install.async.Task|ts-install.async.Closable
local Task = {}

do --- Task
  Task.__index = Task
  --- @package
  --- @param func function
  --- @return ts-install.async.Task
  function Task._new(func)
    local thread = coroutine.create(function(marker, ...)
      check_yield(marker)
      return func(...)
    end)

    local self = setmetatable({
      _closing = false,
      _thread = thread,
      _future = M.future(),
      _children_idx = 0,
    }, Task)

    threads[thread] = self

    return self
  end

  --- @return boolean
  function Task:cancelled()
    return self._future._err == 'closed'
  end

  --- @package
  function Task:_unwait(cb)
    return self._future:_remove_cb(cb)
  end

  --- Returns whether the Task has completed.
  --- @return boolean
  function Task:completed()
    return self._future:completed()
  end

  --- Add a callback to be run when the Task has completed.
  ---
  --- - If a timeout or `nil` is provided, the Task will synchronously wait for the
  ---   task to complete for the given time in milliseconds.
  ---
  ---   ```lua
  ---   local result = task:wait(10) -- wait for 10ms or else error
  ---
  ---   local result = task:wait() -- wait indefinitely
  ---   ```
  ---
  --- - If a function is provided, it will be called when the Task has completed
  ---   with the arguments:
  ---   - (`err: string`) - if the Task completed with an error.
  ---   - (`nil`, `...:any`) - the results of the Task if it completed successfully.
  ---
  ---
  --- If the Task is already done when this method is called, the callback is
  --- called immediately with the results.
  --- @param callback_or_timeout integer|fun(err?: any, ...: R...)?
  --- @overload fun(timeout?: integer): R...
  function Task:wait(callback_or_timeout)
    if is_callable(callback_or_timeout) then
      self._future:wait(callback_or_timeout)
      return
    end

    if
      not vim.wait(callback_or_timeout or MAX_TIMEOUT, function()
        return self:completed()
      end)
    then
      error('timeout', 2)
    end

    local res = pack_len(self._future:result())

    assert(self:status() == 'dead' or res[2] == yield_error)

    if not res[1] then
      error(res[2], 2)
    end

    return unpack_len(res, 2)
  end

  --- If a task completes with an error, raise the error
  --- @return ts-install.async.Task self
  function Task:raise_on_error()
    self:wait(function(err)
      if err then
        error(err, 0)
      end
    end)
    return self
  end

  --- Close the task and all of its children.
  --- If callback is provided it will run asynchronously,
  --- else it will run synchronously.
  ---
  --- @param callback? fun()
  function Task:close(callback)
    if not self:completed() and not self._closing then
      self._closing = true
      self:_resume('closed')
    end
    if callback then
      self:wait(function()
        callback()
      end)
    end
  end

  do -- Task:_resume()
    --- Should only be called in Task:_resume_co()
    --- @param task ts-install.async.Task
    --- @param stat boolean
    --- @param ... any result
    local function finish(task, stat, ...)
      threads[task._thread] = nil

      if not stat then
        task._future:complete((...) or 'unknown error')
      else
        task._future:complete(nil, ...)
      end
    end

    --- @param thread thread
    --- @param on_finish fun(stat: boolean, ...:any)
    --- @param stat boolean
    --- @return fun(callback: fun(...:any...): ts-install.async.Closable?)?
    local function handle_co_resume(thread, on_finish, stat, ...)
      if not stat or coroutine.status(thread) == 'dead' then
        on_finish(stat, ...)
        return
      end

      local marker, fn = ...

      if marker ~= yield_marker or not is_callable(fn) then
        on_finish(false, yield_error)
        return
      end

      return fn
    end

    --- @param awaitable fun(callback: fun(...:any...): ts-install.async.Closable?)
    --- @param on_defer fun(err?:any, ...:any)
    --- @return any[]? next_args
    --- @return ts-install.async.Closable? closable
    local function handle_awaitable(awaitable, on_defer)
      local ok, closable_or_err
      local settled = false
      local next_args --- @type any[]?
      ok, closable_or_err = pcall(awaitable, function(...)
        if settled then
          -- error here?
          return
        end
        settled = true

        if ok == nil then
          next_args = pack_len(...)
        else
          on_defer(...)
        end
      end)

      if not ok then
        return pack_len(closable_or_err)
      elseif is_closable(closable_or_err) then
        return next_args, closable_or_err
      else
        return next_args
      end
    end

    --- @param awaiting ts-install.async.Task|ts-install.async.Closable
    --- @return boolean
    local function can_close_awaiting(awaiting)
      return getmetatable(awaiting) ~= Task
    end

    --- @package
    --- @param ... any the first argument is the error, except for when the coroutine begins
    function Task:_resume(...)
      --- @type {[integer]: any, n: integer}?
      local args = pack_len(...)

      -- Run this block in a while loop to run non-deferred continuations
      -- without a new stack frame.
      while args do
        -- TODO(lewis6991): Add a test that handles awaiting in the non-deferred
        -- continuation

        -- handling awaiting
        local awaiting = self._awaiting
        if awaiting and can_close_awaiting(awaiting) then
          -- We must close the closable child before we resume to ensure
          -- all resources are collected.
          --- @diagnostic disable-next-line: param-type-not-match
          local close_ok, close_err = pcall(awaiting.close, awaiting, function()
            self._awaiting = nil
            self:_resume(unpack_len(args))
          end)

          if close_ok then
            -- _resume will continue in close callback
            return
          end

          -- Close failed (synchronously) raise error
          args = pack_len(close_err)
        end

        if coroutine.status(self._thread) == 'dead' then
          -- Can only happen if coroutine.resume() is called outside of this
          -- function. When that happens check_yield() will error the coroutine
          -- which puts it in the 'dead' state.
          finish(self, false, (...))
          return
        end

        local awaitable = handle_co_resume(self._thread, function(stat, ...)
          finish(self, stat, ...)
        end, coroutine.resume(self._thread, resume_marker, unpack_len(args)))

        if not awaitable then
          return
        end

        args, self._awaiting = handle_awaitable(awaitable, function(...)
          if not self:completed() then
            self:_resume(...)
          end
        end)
      end
    end
  end

  --- Returns the status of tasks thread. See [coroutine.status()].
  --- @return 'running'|'suspended'|'normal'|'dead'?
  function Task:status()
    return coroutine.status(self._thread)
  end
end

--- Run a function in an async context, asynchronously.
---
--- Returns an [ts-install.async.Task] object which can be used to wait or await the result
--- of the function.
--- @generic T, R
--- @param func async fun(...:T...): R... Function to run in an async context
--- @param ... T... Arguments to pass to the function
--- @return ts-install.async.Task<R>
function M.run(func, ...)
  -- TODO(lewis6991): add task names
  local task = Task._new(func)
  task:_resume(...)
  return task
end

--- Returns true if the current task has been cancelled.
--- @return boolean
function M.is_closing()
  local task = running()
  return task and task._closing or false
end

do --- M.await()
  --- @generic T, R
  --- @param argc integer
  --- @param fun fun(...: T, callback: fun(...: R...))
  --- @param ... any func arguments
  --- @return fun(callback: fun(...: R...))
  local function norm_cb_fun(argc, fun, ...)
    local args = pack_len(...)

    --- @param callback fun(...:any)
    --- @return any?
    return function(callback)
      args[argc] = function(...)
        callback(nil, ...)
      end
      args.n = math.max(args.n, argc)
      return fun(unpack_len(args))
    end
  end

  --- Asynchronous blocking wait
  --- @async
  --- @generic T, R
  --- @param ... any see overloads
  --- @overload async fun(func: (fun(callback: fun(...:R...)): ts-install.async.Closable?)): R...
  --- @overload async fun(argc: integer, func: (fun(...:T..., callback: fun(...:R...)): ts-install.async.Closable?), ...:T...): R...
  --- @overload async fun(task: ts-install.async.Task<R>): R...
  function M.await(...)
    local task = running()
    assert(task, 'Not in async context')

    -- TODO(lewis6991): needs test coverage. Happens when a task pcalls an await
    if task._closing then
      error('closed', 0)
    end

    local arg1 = select(1, ...)

    local fn --- @type fun(...:R...): ts-install.async.Closable?
    if type(arg1) == 'number' then
      fn = norm_cb_fun(...)
    elseif type(arg1) == 'function' then
      fn = norm_cb_fun(1, arg1)
    elseif getmetatable(arg1) == Task then
      fn = function(callback)
        arg1:wait(callback)
        return arg1
      end
    else
      error('Invalid arguments, expected Task or (argc, func) got: ' .. vim.inspect(arg1), 2)
    end

    return check_yield(coroutine.yield(yield_marker, fn))
  end
end

--- Creates an async function with a callback style function.
---
--- `func` can optionally return an object with a close method to clean up
--- resources. Note this method will be called when the task finishes or
--- interrupted.
--- @generic T, R
--- @param argc integer
--- @param func fun(...: T, callback: fun(...: R)): ts-install.async.Closable?
--- @return async fun(...:T): R
function M.wrap(argc, func)
  assert(type(argc) == 'number')
  assert(type(func) == 'function')
  --- @async
  return function(...)
    return M.await(argc, func, ...)
  end
end

--- Waits for multiple tasks to finish and iterates over their results.
---
--- This function allows you to run multiple asynchronous tasks concurrently and
--- process their results as they complete. It returns an iterator function that
--- yields the index of the task, any error encountered, and the results of the
--- task.
---
--- If a task completes with an error, the error is returned as the second
--- value. Otherwise, the results of the task are returned as subsequent values.
--- @async
--- @param tasks ts-install.async.Task<any>[] A list of tasks to wait for and iterate over.
--- @return async fun(): (integer?, any?, ...any) iterator that yields the index, error, and results of each task.
function M.iter(tasks)
  -- TODO(lewis6991): do not return err, instead raise any errors as they occur
  assert(running(), 'Not in async context')

  local results = {} --- @type [integer, any, ...any][]

  -- Iter blocks in an async context so only one waiter is needed
  local waiter = nil --- @type fun(index: integer?, err?: any, ...: any)?

  local remaining = #tasks

  -- Keep track of the callbacks so we can remove them when the iterator
  -- is garbage collected.
  --- @type table<ts-install.async.Task<any>,function>
  local task_cbs = setmetatable({}, { __mode = 'v' })

  -- Wait on all the tasks. Keep references to the task futures and wait
  -- callbacks so we can remove them when the iterator is garbage collected.
  for i, task in ipairs(tasks) do
    local function cb(err, ...)
      local callback = waiter

      -- Clear waiter before calling it
      waiter = nil

      remaining = remaining - 1
      if callback then
        -- Iterator is waiting, yield to it
        callback(i, err, ...)
      else
        -- Task finished before Iterator was called. Store results.
        table.insert(results, pack_len(i, err, ...))
      end
    end

    task_cbs[task] = cb
    task:wait(cb)
  end

  return gc_fun(
    M.wrap(1, function(callback)
      if next(results) then
        local res = table.remove(results, 1)
        callback(unpack_len(res))
      elseif remaining == 0 then
        callback() -- finish
      else
        assert(not waiter, 'internal error: waiter already set')
        waiter = callback
      end
    end),
    function()
      for t, tcb in pairs(task_cbs) do
        t:_unwait(tcb)
      end
    end
  )
end

--- Wait for all tasks to finish and return their results.
--- @async
--- @param tasks ts-install.async.Task<any>[]
--- @return table<integer,[any?,...?]>
function M.await_all(tasks)
  assert(running(), 'Not in async context')
  local iter = M.iter(tasks)
  local results = {} --- @type table<integer,table>

  local function collect(i, ...)
    if i then
      results[i] = pack_len(...)
    end
    return i ~= nil
  end

  while collect(iter()) do
  end

  return results
end

--- @async
--- @param duration integer ms
function M.sleep(duration)
  M.await(1, function(callback)
    -- TODO(lewis6991): should return the result of defer_fn here.
    vim.defer_fn(callback, duration)
  end)
end

do --- M.future()
  --- Future objects are used to bridge low-level callback-based code with
  --- high-level async/await code.
  --- @class ts-install.async.Future<R>
  --- @field private _callbacks table<integer,fun(err?: any, ...: R...)>
  --- @field private _callback_pos integer
  --- Error result of the task is an error occurs.
  --- Must use `await` to get the result.
  --- @field package _err? any
  ---
  --- Result of the task.
  --- Must use `await` to get the result.
  --- @field private _result? R[]
  local Future = {}
  Future.__index = Future

  --- Return `true` if the Future is completed.
  --- @return boolean
  function Future:completed()
    return (self._err or self._result) ~= nil
  end

  --- Return the result of the Future.
  ---
  --- If the Future is done and has a result set by the `complete()` method, the
  --- result is returned.
  ---
  --- If the Future’s result isn’t yet available, this method raises a
  --- "Future has not completed" error.
  --- @return boolean stat
  --- @return any ... error or result
  function Future:result()
    if not self:completed() then
      error('Future has not completed', 2)
    end
    if self._err then
      return false, self._err
    else
      return true, unpack_len(self._result)
    end
  end

  --- Add a callback to be run when the Future is done.
  ---
  --- The callback is called with the arguments:
  --- - (`err: string`) - if the Future completed with an error.
  --- - (`nil`, `...:any`) - the results of the Future if it completed successfully.
  ---
  --- If the Future is already done when this method is called, the callback is
  --- called immediately with the results.
  --- @param callback fun(err?: any, ...: any)
  function Future:wait(callback)
    if self:completed() then
      -- Already finished or closed
      callback(self._err, unpack_len(self._result))
    else
      self._callbacks[self._callback_pos] = callback
      self._callback_pos = self._callback_pos + 1
    end
  end

  -- Mark the Future as complete and set its err or result.
  --- @param err? any
  --- @param ... any result
  function Future:complete(err, ...)
    if err ~= nil then
      self._err = err
    else
      self._result = pack_len(...)
    end

    local errs = {} --- @type string[]
    -- Need to use pairs to avoid gaps caused by removed callbacks
    for _, cb in pairs(self._callbacks) do
      local ok, cb_err = pcall(cb, err, ...)
      if not ok then
        errs[#errs + 1] = cb_err
      end
    end

    if #errs > 0 then
      error(table.concat(errs, '\n'), 0)
    end
  end

  --- @param cb fun(err?: any, ...: any)
  function Future:_remove_cb(cb)
    for j, fcb in pairs(self._callbacks) do
      if fcb == cb then
        self._callbacks[j] = nil
        break
      end
    end
  end

  --- Create a new future
  --- @return ts-install.async.Future
  function M.future()
    return setmetatable({
      _callbacks = {},
      _callback_pos = 1,
    }, Future)
  end
end

return M
