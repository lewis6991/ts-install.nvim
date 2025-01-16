local M = {}

--- @class ts.AsyncTask.Handle
--- @field close fun(self, callback: fun())

--- @class ts.AsyncTask
--- @field private _thread thread
--- @field private _callbacks function[]
--- @field private _obj? ts.AsyncTask.Handle
--- @field private _closing? true
--- @field err? any
--- @field result? any[]
local Task = {}

--- @return ts.AsyncTask
function Task.new(func)
  return setmetatable({
    _thread = coroutine.create(func),
    _callbacks = {},
  }, { __index = Task })
end

--- @package
--- @param ... any
function Task:_resume(...)
  local ret = { coroutine.resume(self._thread, ...) }
  local stat = ret[1]

  if not stat then
    local err = ret[2] --- @type string
    -- REVISIT lewrus01 (16/01/25): add debug.traceback(task.thread) ?
    self:_complete(err)
  elseif coroutine.status(self._thread) == 'dead' then
    table.remove(ret, 1)
    self:_complete(nil, ret)
  else
    local fn = ret[2] --- @type fun(...: any): any

    assert(type(fn) == 'function', 'type error :: expected func')

    local ok, obj_or_err = pcall(fn, function(...)
      self:_resume(...)
    end)

    if ok then
      self._obj = obj_or_err
    else
      self:_complete(obj_or_err)
    end
  end
end

--- @private
function Task:_completed()
  return (self.err or self.result) ~= nil
end

--- @param callback fun(err?: any, ret?: any[])
function Task:await(callback)
  if self:_completed() then
    callback(self.err, self.result)
  else
    self._callbacks[#self._callbacks + 1] = callback
  end
end

--- @private
function Task:_error(err)
  error(('Async task with %s error: %s'):format(self._thread, err), 2)
end

--- @private
function Task:_on_close()
  for _, cb in ipairs(self._callbacks) do
    cb(self.err, self.result)
  end
end

--- @private
--- @param err? any
--- @param result? any[]
--- @param callback? fun(err?: any, ret?: any[])
function Task:_complete(err, result, callback)
  if self:_completed() then
    self:_error('Already finished')
  end

  if callback then
    self:await(function()
      callback()
    end)
  end

  self.err = err
  self.result = result

  if self._obj and self._obj.close then
    self._closing = true
    -- REVISIT lewrus01 (16/01/25): add a timer to ensure callback is called
    self._obj:close(function()
      -- If we finish whilst waiting for close to finish
      -- then do not call _on_done again
      if not self:_completed() then
        self:_on_close()
      end
    end)
  else
    self:_on_close()
  end
end

--- @return 'active' | 'completed' | 'closing'
function Task:status()
  if self._closing then
    return 'closing'
  elseif self:_completed() then
    return 'completed'
  else
    return 'active'
  end
end

--- @param callback fun(err?: any, ret?: any[])
function Task:close(callback)
  if self._closing then
    self:_error('Already closing')
  elseif self:_completed() then
    self:_error('Already finished')
  else
    self:_complete('closed', nil, callback)
  end
end

--- @param timeout? integer
--- @return any ...
function Task:wait(timeout)
  if not vim.wait(timeout or 10000, function()
    return self:_completed()
  end) then
    error('timeout')
  end

  if self.err then
    error(self.err)
  end

  return unpack(self.result, 1, self.result.n)
end

--- Executes a future with a callback when it is done
--- @param func function
--- @param ... any
--- @return ts.AsyncTask
function M.run(func, ...)
  local task = Task.new(func)
  task:_resume(...)
  return task
end

--- @param task ts.AsyncTask
local function await_task(task)
  return coroutine.yield(function(cb)
    task:await(cb)
  end)
end

--- @param argc integer
--- @param func function
--- @param ... any
--- @return any ...
local function await_cbfun(argc, func, ...)
  local argn = math.max(argc, select('#', ...))
  local args = { ... }
  return coroutine.yield(function(cb)
    args[argc] = cb
    return func(unpack(args, 1, argn))
  end)
end

--- @overload fun(task: ts.AsyncTask): any
--- @overload fun(argc: integer, func: function, ...: any): any
function M.await(...)
  if type(select(1, ...)) == 'number' then
    return await_cbfun(...)
  else
    return await_task(...)
  end
end

--- Creates an async function with a callback style function.
--- @generic F: function
--- @param argc integer
--- @param func F
--- @return F
function M.wrap(argc, func)
  assert(type(func) == 'function')
  assert(type(argc) == 'number')
  return function(...)
    return M.await(argc, func, ...)
  end
end

--- create([argc, ] func)
---
--- Use this to create a function which executes in an async context but
--- called from a non-async context. Inherently this cannot return anything
--- since it is non-blocking
---
--- If argc is not provided, then the created async function cannot be continued
---
--- @generic F: function
--- @param argc_or_func F|integer
--- @param func? F
--- @return F
function M.create(argc_or_func, func)
  local argc --- @type integer
  if type(argc_or_func) == 'function' then
    assert(not func)
    func = argc_or_func
  elseif type(argc_or_func) == 'number' then
    assert(type(func) == 'function')
    argc = argc_or_func
  end

  --- @cast func function

  return function(...)
    local callback = argc and select(argc + 1, ...) or nil
    local task = M.run(func, unpack({ ... }, 1, argc))
    if callback then
      assert(type(callback) == 'function')
      task:await(function(err, result)
        if err then
          error(err)
        end
        callback(unpack(result, 1, result.n))
      end)
    end
    return task
  end
end

--- @async
--- @param tasks ts.AsyncTask[]
--- @return any
function M.join(tasks)
  if #tasks == 0 then
    return
  end

  return M.await(1, function(finish)
    local to_go = #tasks
    local ret = {} --- @type any[]

    local function cb(...)
      ret[#ret + 1] = { ... }
      to_go = to_go - 1
      if to_go == 0 then
        finish(ret)
      end
    end

    for _, task in ipairs(tasks) do
      task:await(cb)
    end
  end)
end

--- An async function that when called will yield to the Neovim scheduler to be
--- able to call the API.
--- @type fun()
M.main = M.wrap(1, vim.schedule)

return M
