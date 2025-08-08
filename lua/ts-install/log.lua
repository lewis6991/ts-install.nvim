local echo = vim.schedule_wrap(vim.api.nvim_echo)

-- TODO(lewis6991): write these out to a file
local messages = {} --- @type {[1]: string, [2]: string?, [3]: string}[]

local sev_to_hl = {
  trace = 'DiagnosticHint',
  debug = 'Normal',
  info = 'MoreMsg',
  warn = 'WarningMsg',
  error = 'ErrorMsg',
}

--- @param ctx string?
--- @return string
local function mkpfx(ctx)
  return ctx and string.format('[ts-install/%s]', ctx) or '[ts-install]'
end

--- @class ts_install.log
--- @field trace fun(fmt: string, ...: any)
--- @field debug fun(fmt: string, ...: any)
--- @field info fun(fmt: string, ...: any)
--- @field warn fun(fmt: string, ...: any)
--- @field error fun(fmt: string, ...: any)
local M = {}

--- @class ts_install.Logger
--- @field ctx? string
local Logger = {}

M.Logger = Logger

--- @param ctx? string
--- @return ts_install.Logger
function M.new(ctx)
  return setmetatable({ ctx = ctx }, { __index = Logger })
end

--- @param m string
--- @param ... any
function Logger:trace(m, ...)
  messages[#messages + 1] = { 'trace', self.ctx, m:format(...) }
end

--- @param m string
--- @param ... any
function Logger:debug(m, ...)
  messages[#messages + 1] = { 'debug', self.ctx, m:format(...) }
end

--- @param str string
--- @param chunk_size integer
--- @return string[]
local function split_string(str, chunk_size)
  local chunks = {} --- @type string[]
  for i = 1, #str, chunk_size do
    chunks[#chunks + 1] = str:sub(i, i + chunk_size - 1)
  end
  return chunks
end

local columns = vim.o.columns

--- @param m string
--- @param hl string
local function echo_split(m, hl)
  -- update columns if we can
  columns = vim.in_fast_event() and columns or vim.o.columns
  -- Trimming the message to fit the screen - 12, avoids the 'Press ENTER' prompt
  local chunks = split_string(m, columns - 12)
  for _, chunk in ipairs(chunks) do
    echo({ { chunk, hl } }, true, {})
  end
end

--- @param m string
--- @param ... any
function Logger:info(m, ...)
  local m1 = m:format(...)
  messages[#messages + 1] = { 'info', self.ctx, m1 }
  echo_split(mkpfx(self.ctx) .. ': ' .. m1, sev_to_hl.info)
end

--- @param m string
--- @param ... any
function Logger:warn(m, ...)
  local m1 = m:format(...)
  messages[#messages + 1] = { 'warn', self.ctx, m1 }
  echo({ { mkpfx(self.ctx) .. ' warning: ' .. m1, sev_to_hl.warn } }, true, {})
end

--- @param m string
--- @param ... any
--- @return string
function Logger:error(m, ...)
  local m1 = m:format(...)
  messages[#messages + 1] = { 'error', self.ctx, debug.traceback(m1) }
  echo({ { mkpfx(self.ctx) .. ' error: ' .. m1, sev_to_hl.error } }, true, {})
  return m1
end

local noctx_logger = M.new()

setmetatable(M, {
  __index = function(t, k)
    --- @diagnostic disable-next-line:no-unknown
    t[k] = function(...)
      return noctx_logger[k](noctx_logger, ...)
    end
    return t[k]
  end,
})

function M.show()
  for _, l in ipairs(messages) do
    local sev, ctx, msg = l[1], l[2], l[3]
    local hl = sev_to_hl[sev]
    local text = ctx and string.format('%s(%s): %s', sev, ctx, msg)
      or string.format('%s: %s', sev, msg)
    -- Do not use vim.schedule_wrap here as we want to show all the messages
    -- without prompts between them
    vim.api.nvim_echo({ { text, hl } }, false, {})
  end
end

return M
