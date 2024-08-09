local M = {}

local function setup_auto_install()
  local config = require('ts-install.config').config
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local parsers = require('ts-install.parsers')
      local buf = args.buf --- @type integer
      local ft = vim.bo[buf].filetype
      local lang = vim.treesitter.language.get_lang(ft) or ft
      if
        parsers.get_parser_info()[lang]
        and not vim.list_contains(parsers.installed(), lang)
        and not vim.list_contains(config.ignore_install, lang)
      then
        require('ts-install.install').install(lang, nil, function()
          -- Need to pcall since 'FileType' can be triggered multiple times
          -- per buffer
          pcall(vim.treesitter.start, buf, lang)
        end)
      end
    end,
  })
end

--- @param langs string[]
local function do_ensure_install(langs)
  local parsers = require('ts-install.parsers')
  local to_install =
    parsers.norm_languages(langs, { ignored = true, installed = true })

  if #to_install > 0 then
    require('ts-install.install').install(to_install, { force = true })
  end
end

---Setup call for users to override configuration configurations.
---@param user_config ts_install.config? user configuration table
function M.setup(user_config)
  local ts_config = require('ts-install.config')
  ts_config.apply(user_config)

  local config = ts_config.config

  vim.opt.runtimepath:append(config.install_dir)

  if config.auto_install then
    setup_auto_install()
  end

  if #config.ensure_install > 0 then
    do_ensure_install(config.ensure_install)
  end
end

return M
