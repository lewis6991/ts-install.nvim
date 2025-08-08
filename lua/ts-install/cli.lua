local async = require('ts-install.async')

local M = {}

--- @param line string
--- @return string[]
local function subcmd_candidates(line)
  local words = vim.split(line, '%s+')
  local n = #words
  if n == 2 then
    return {
      'install',
      'update',
      'uninstall',
      'log',
    }
  elseif n > 2 then
    local subcmd = words[2]
    if subcmd == 'install' then
      local r = require('ts-install.parsers').get_available()
      r[#r + 1] = 'all'
      r[#r + 1] = '--generate'
      return r
    elseif subcmd == 'update' or subcmd == 'uninstall' then
      --- @type string[]
      local r = async.run(require('ts-install.parsers').installed):wait()
      r[#r + 1] = 'all'
      return r
    end
  end
  return {}
end

function M.complete(arglead, line)
  local isflag = arglead:match('^%-') ~= nil
  return vim.tbl_filter(
    --- @param v string
    function(v)
      if isflag then
        return vim.startswith(v, arglead)
      end
      return v:find(vim.pesc(arglead)) ~= nil
    end,
    subcmd_candidates(line)
  )
end

--- @param args string[]
--- @return string[] args
--- @return table<string,true> opts
local function extract_opts(args)
  local args1 = {} --- @type string[]
  local opts = {} --- @type table<string,true>

  for _, v in ipairs(args) do
    local opt = v:match('^%-%-([^ ]+)') or v:match('^%-([^ ]+)')
    if opt then
      opts[opt] = true
    else
      args1[#args1 + 1] = v
    end
  end

  return args1, opts
end

--- @param args vim.api.keyset.create_user_command.command_args
function M.run(args)
  local subcmd = args.fargs[1]
  local fargs, opts = extract_opts(vim.list_slice(args.fargs, 2))

  opts.force = opts.force or args.bang

  async.run(function()
    local installer = require('ts-install.install')

    if subcmd == 'install' then
      installer.install(fargs, opts --[[@as ts_install.install.InstallOpts]])
    elseif subcmd == 'update' then
      installer.update(fargs)
    elseif subcmd == 'uninstall' then
      installer.uninstall(fargs)
    elseif subcmd == 'log' then
      require('ts-install.log').show()
    end
  end)
end

return M
