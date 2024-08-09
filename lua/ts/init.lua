local M = {}

---Setup call for users to override configuration configurations.
---@param user_config ts.config? user configuration table
function M.setup(user_config)
  local ts_config = require('ts.config')
  ts_config.apply(user_config)

  local config = ts_config.config

  if config.install_dir then
    vim.opt.runtimepath:append(config.install_dir)
  end

  if config.auto_install then
    local parsers = require('ts.parsers')
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local buf = args.buf --- @type integer
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft) or ft
        if
          require('ts.parser_info')[lang]
          and not vim.list_contains(parsers.installed(), lang)
          and not vim.list_contains(config.ignore_install, lang)
        then
          require('ts.install').install(lang, nil, function()
            -- Need to pcall since 'FileType' can be triggered multiple times
            -- per buffer
            pcall(vim.treesitter.start, buf, lang)
          end)
        end
      end,
    })
  end

  if #config.ensure_install > 0 then
    local parsers = require('ts.parsers')
    local to_install = parsers.norm_languages(config.ensure_install, { ignored = true, installed = true })

    if #to_install > 0 then
      require('ts.install').install(to_install, { force = true })
    end
  end
end

return M
