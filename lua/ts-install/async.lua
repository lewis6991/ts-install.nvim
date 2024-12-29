local M = {}

--- Executes a future with a callback when it is done
--- @param func function
--- @param callback? function
--- @param ... unknown
local function run(func, callback, ...)
  local co = coroutine.create(func)

  local function step(...)
    local ret = { coroutine.resume(co, ...) }
    local stat = ret[1]

    if not stat then
      local err = ret[2] --- @type string
      error(debug.traceback(co, ('The async coroutine failed: %s'):format(err)))
    end

    if coroutine.status(co) == 'dead' then
      if callback then
        callback(unpack(ret, 2, table.maxn(ret)))
      end
      return
    end

    local fn = ret[2] --- @type fun(...: any): any

    assert(type(fn) == 'function', 'type error :: expected func')

    -- Always run the wrapped functions in xpcall and re-raise the error in the
    -- coroutine. This makes pcall work as normal.
    xpcall(fn, function(err)
      step(false, { err, debug.traceback() })
    end, function(...)
      step(true, { n = select('#', ...), ... })
    end)
  end

  -- The first invocation of the coroutine is the entry to `func`, so pass
  -- `...`. Subsequent invocations are resumed into wrapped functions which
  -- expects a status and the return values (callback arguments).
  step(...)
end

--- @param argc integer
--- @param func function
--- @param ... any
--- @return any ...
function M.wait(argc, func, ...)
  local args = { n = select('#', ...), ... }

  local ok, ret = coroutine.yield(function(cb)
    args[argc] = cb
    return func(unpack(args, 1, math.max(argc, args.n)))
  end)

  if not ok then
    --- @type string, string
    local err, traceback = ret[2], ret[3]
    error(('Wrapped function failed: %s\n%s'):format(err, traceback))
  end

  return unpack(ret, 1, assert(ret.n))
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
    return M.wait(argc, func, ...)
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
    assert(not callback or type(callback) == 'function')
    return run(func, callback, unpack({ ... }, 1, argc))
  end
end

function M.run(func, ...)
  return run(func, nil, ...)
end

--- Use this to create a function which executes in an async context but
--- called from a non-async context. Inherently this cannot return anything
--- since it is non-blocking
--- @param func async function
--- @param timeout? integer
function M.sync(func, timeout)
  local done = false
  local ret --- @type table
  run(func, function(...)
    done = true
    ret = { n = select('#', ...), ... }
  end)

  vim.wait(timeout or 10000, function()
    return done
  end, 100)

  if ret then
    return unpack(ret, 1, ret.n)
  end
end

--- @param n integer max number of concurrent jobs
--- @param interrupt_check? function
--- @param thunks function[]
--- @return any
function M.join(n, interrupt_check, thunks)
  return M.wait(1, function(finish)
    if #thunks == 0 then
      return finish()
    end

    local remaining = { select(n + 1, unpack(thunks)) }
    local to_go = #thunks

    local ret = {} --- @type any[]

    local function cb(...)
      ret[#ret + 1] = { ... }
      to_go = to_go - 1
      if to_go == 0 then
        finish(ret)
      elseif not interrupt_check or not interrupt_check() then
        if #remaining > 0 then
          local next_task = table.remove(remaining)
          next_task(cb)
        end
      end
    end

    for i = 1, math.min(n, #thunks) do
      thunks[i](cb)
    end
  end)
end

--- An async function that when called will yield to the Neovim scheduler to be
--- able to call the API.
--- @type fun()
M.main = M.wrap(1, vim.schedule)

return M
