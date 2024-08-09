if vim.g.loaded_ts_nvim then
  return
end
vim.g.loaded_ts_nvim = true

local api = vim.api

local function subcmd_candidates(line)
  local words = vim.split(line, '%s+')
  local n = #words
  if n == 2 then
    return {
      'install',
      'install_from_grammar',
      'update',
      'uninstall',
      'log',
    }
  elseif n > 2 then
    local subcmd = words[2]
    if subcmd == 'install' or subcmd == 'install_from_grammar' then
      return require('ts.parsers').get_available()
    elseif subcmd == 'update' or subcmd == 'uninstall' then
      return require('ts.parsers').installed()
    end
  end
end

local function subcmd_complete(arglead, line)
  return vim.tbl_filter(
    --- @param v string
    function(v)
      return v:find(arglead) ~= nil
    end,
    subcmd_candidates(line) or {}
  )
end

-- create user commands
api.nvim_create_user_command('TS', function(args)
  local subcmd = args.fargs[1] --- @type string
  local sub_fargs = vim.list_slice(args.fargs, 2)
  if subcmd == 'install' then
    require('ts.install').install(sub_fargs, { force = args.bang })
  elseif subcmd == 'install_from_grammar' then
    require('ts.install').install(sub_fargs, {
      generate = true,
      force = args.bang,
    })
  elseif subcmd == 'update' then
    require('ts.install').update(sub_fargs)
  elseif subcmd == 'uninstall' then
    require('ts.install').uninstall(sub_fargs)
  elseif subcmd == 'log' then
    require('ts.log').show()
  end
end, {
  nargs = '+',
  bang = true,
  bar = true,
  complete = subcmd_complete,
  desc = 'ts.nvim command interface',
})
