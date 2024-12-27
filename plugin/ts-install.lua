if vim.g.loaded_ts_nvim then
  return
end
vim.g.loaded_ts_nvim = true

vim.api.nvim_create_user_command('TS', function(args)
  require('ts-install.cli').run(args)
end, {
  nargs = '+',
  bang = true,
  bar = true,
  complete = function(arglead, line)
    return require('ts-install.cli').complete(arglead, line)
  end,
  desc = 'ts-install.nvim command interface',
})
