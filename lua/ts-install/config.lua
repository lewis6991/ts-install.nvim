--- @class ts_install.config
--- @field auto_install? boolean
--- @field auto_update? boolean
--- @field ensure_install? string[]
--- @field ignore_install? string[]
--- @field install_dir? string
--- @field parsers? table<string,ts_install.ParserInfo>

--- @class ts_install.config.normalized
--- @field auto_install boolean
--- @field auto_update boolean
--- @field ensure_install string[]
--- @field ignore_install string[]
--- @field install_dir string
--- @field parsers table<string,ts_install.ParserInfo>

local M = {}

local std_data = vim.fn.stdpath('data') --[[@as string]]

---@type ts_install.config.normalized
M.config = {
  -- REVISIT lewrus01 (09/08/24): default to true when we switch to wasm
  auto_install = false,
  auto_update = true,
  ensure_install = {},
  ignore_install = {},
  install_dir = vim.fs.joinpath(std_data, 'ts-install'),
  parsers = {},
}

--- Apply user configuration.
--- @param user_config ts_install.config? user configuration table
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
