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

local MAX_TIMEOUT = 2 ^ 31 - 1

vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    local install = package.loaded['ts-install.install']
    if not install or not install.has_pending() then
      return
    end

    local warning = vim.defer_fn(function()
      vim.api.nvim_echo({
        { 'Waiting for parser installation (Press Ctrl-C to force exit)', 'WarningMsg' },
      }, true, {})
    end, 100)

    -- vim.wait() keeps processing callbacks and Ctrl-C interrupts the wait.
    vim.wait(MAX_TIMEOUT, function()
      return not install.has_pending()
    end)

    if not warning:is_closing() then
      warning:close()
    end
  end,
  desc = 'Wait for parser installation before exiting',
})
