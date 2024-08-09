local M = {}

---Executes a future with a callback when it is done
--- @param func function
--- @param callback function
--- @param ... unknown
local function execute(func, callback, ...)
  local thread = coroutine.create(func)

  local function step(...)
    local ret = { coroutine.resume(thread, ...) }
    --- @type boolean, any
    local stat, nargs_or_err = unpack(ret)

    if not stat then
      error(
        string.format(
          'The coroutine failed with this message: %s\n%s',
          nargs_or_err,
          debug.traceback(thread)
        )
      )
    end

    if coroutine.status(thread) == 'dead' then
      if callback then
        callback(unpack(ret, 3, table.maxn(ret)))
      end
      return
    end

    --- @type function, any[]
    local fn, args = ret[3], { unpack(ret, 4, table.maxn(ret)) }
    args[nargs_or_err] = step
    fn(unpack(args, 1, nargs_or_err))
  end

  step(...)
end

--- Creates an async function with a callback style function.
--- @generic F: function
--- @param argc integer
--- @param func F
--- @return F
function M.wrap(argc, func)
  vim.validate({
    func = { func, 'function' },
    argc = { argc, 'number' },
  })
  --- @param ... unknown
  --- @return unknown
  return function(...)
    return coroutine.yield(argc, func, ...)
  end
end

---Use this to create a function which executes in an async context but
---called from a non-async context. Inherently this cannot return anything
---since it is non-blocking
--- @generic F: function
--- @param nargs integer
--- @param func async F
--- @return F
function M.sync(nargs, func)
  return function(...)
    local callback = select(nargs + 1, ...)
    execute(func, callback, unpack({ ... }, 1, nargs))
  end
end

--- @param n integer max number of concurrent jobs
--- @param interrupt_check? function
--- @param thunks function[]
--- @return any
function M.join(n, interrupt_check, thunks)
  return coroutine.yield(1, function(finish)
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
  end, 1)
end

---An async function that when called will yield to the Neovim scheduler to be
---able to call the API.
--- @type fun()
M.main = M.wrap(1, vim.schedule)

return M
