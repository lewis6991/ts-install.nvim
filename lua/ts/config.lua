--- @class ts.config
--- @field auto_install boolean
--- @field ensure_install string[]
--- @field ignore_install string[]
--- @field install_dir string

local M = {}

local std_data = vim.fn.stdpath('data') --[[@as string]]

---@type ts.config
M.config = {
  auto_install = false,
  ensure_install = {},
  ignore_install = { 'unsupported' },
  install_dir = vim.fs.joinpath(std_data, 'ts'),
}

--- Apply user configuration.
--- @param user_config ts.config? user configuration table
function M.apply(user_config)
  if not user_config then
    return
  end

  if user_config.install_dir then
    user_config.install_dir = vim.fs.normalize(user_config.install_dir)
  end

  M.config = vim.tbl_deep_extend('force', M.config, user_config)
end

return M
