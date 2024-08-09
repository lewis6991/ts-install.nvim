if vim.g.loaded_ts_nvim then
  return
end
vim.g.loaded_ts_nvim = true

local api = vim.api

local function complete_available_parsers(arglead)
  return vim.tbl_filter(
    --- @param v string
    function(v)
      return v:find(arglead) ~= nil
    end,
    require('ts.parsers').get_available()
  )
end

local function complete_installed_parsers(arglead)
  return vim.tbl_filter(
    --- @param v string
    function(v)
      return v:find(arglead) ~= nil
    end,
    require('ts.parsers').installed()
  )
end

-- create user commands
api.nvim_create_user_command('TSInstall', function(args)
  require('ts.install').install(args.fargs, { force = args.bang })
end, {
  nargs = '+',
  bang = true,
  bar = true,
  complete = complete_available_parsers,
  desc = 'Install treesitter parsers',
})

api.nvim_create_user_command('TSInstallFromGrammar', function(args)
  require('ts.install').install(args.fargs, {
    generate = true,
    force = args.bang,
  })
end, {
  nargs = '+',
  bang = true,
  bar = true,
  complete = complete_available_parsers,
  desc = 'Install treesitter parsers from grammar',
})

api.nvim_create_user_command('TSUpdate', function(args)
  require('ts.install').update(args.fargs)
end, {
  nargs = '*',
  bar = true,
  complete = complete_installed_parsers,
  desc = 'Update installed treesitter parsers',
})

api.nvim_create_user_command('TSUninstall', function(args)
  require('ts.install').uninstall(args.fargs)
end, {
  nargs = '+',
  bar = true,
  complete = complete_installed_parsers,
  desc = 'Uninstall treesitter parsers',
})

api.nvim_create_user_command('TSLog', function()
  require('ts.log').show()
end, {
  desc = 'View log messages',
})
