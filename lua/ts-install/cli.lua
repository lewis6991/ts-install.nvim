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
    if subcmd == 'install' or subcmd == 'install_from_grammar' then
      local langs = require('ts-install.parsers').get_available()
      table.insert(langs, 'all')
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
  return vim.tbl_filter(
    --- @param v string
    function(v)
      return v:find(arglead) ~= nil
    end,
    subcmd_candidates(line) or {}
  )
end

-- create user commands
--- @param args vim.api.keyset.create_user_command.command_args
function M.run(args)
  local subcmd = args.fargs[1] --- @type string
  local sub_fargs = vim.list_slice(args.fargs, 2)

  local opts = {} --- @type table<string,true>

  while sub_fargs[1] do
    local name = sub_fargs[1]:match('^%-%-([^ ]+)') or sub_fargs[1]:match('^%-([^ ]+)')
    if not name then
      break
    end
    name = ({ g = 'generate' })[name] or name
    opts[name] = true
    sub_fargs = vim.list_slice(sub_fargs, 2)
  end

  opts.force = opts.force or args.bang

  local installer = require('ts-install.install')

  if subcmd == 'install' then
    installer.install(sub_fargs, opts)
  elseif subcmd == 'update' then
    installer.update(sub_fargs)
  elseif subcmd == 'uninstall' then
    installer.uninstall(sub_fargs)
  elseif subcmd == 'log' then
    require('ts-install.log').show()
  end
end

return M
