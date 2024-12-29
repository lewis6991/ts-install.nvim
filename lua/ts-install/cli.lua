local M = {}

--- @async
--- @param line string
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
      local langs = require('ts-install.parsers').get_available()
      table.insert(langs, 'all')
      table.insert(langs, '--generate')
      return langs
    elseif subcmd == 'update' or subcmd == 'uninstall' then
      --- @type string[]
      local langs = require('ts-install.async').sync(function()
        return require('ts-install.parsers').installed()
      end)
      table.insert(langs, 'all')
      return langs
    end
  end
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
    subcmd_candidates(line) or {}
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

-- create user commands
--- @param args vim.api.keyset.create_user_command.command_args
function M.run(args)
  local subcmd = args.fargs[1] --- @type string
  local fargs, opts = extract_opts(vim.list_slice(args.fargs, 2))

  opts.force = opts.force or args.bang

  local installer = require('ts-install.install')

  if subcmd == 'install' then
    installer.install(fargs, opts)
  elseif subcmd == 'update' then
    installer.update(fargs)
  elseif subcmd == 'uninstall' then
    installer.uninstall(fargs)
  elseif subcmd == 'log' then
    require('ts-install.log').show()
  end
end

return M
