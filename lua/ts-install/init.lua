local M = {}

local function setup_auto_install()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf = args.buf
      local ft = vim.bo[args.buf].filetype
      local lang = vim.treesitter.language.get_lang(ft) or ft
      if lang == '' then
        return
      end
      --- @diagnostic disable-next-line: redundant-parameter
      require('ts-install.install').install(lang, { _auto = true }, function(did_not_install)
        if not did_not_install then
          vim.schedule(function()
            -- Retrigger FileType event to start treesitter.
            vim.bo[buf].filetype = vim.bo[buf].filetype
          end)
        end
      end)
    end,
  })
end

--- @param sources string[]
local function do_auto_update(sources)
  local config = require('ts-install.config').config
  local timestamp_path = vim.fs.joinpath(config.install_dir, 'update_timestamp')
  local timestamp_stat = vim.uv.fs_stat(timestamp_path)

  local needs_update = false
  if not timestamp_stat then
    needs_update = true
  else
    for _, source in ipairs(sources) do
      local source_stat = vim.uv.fs_stat(source)
      if source_stat and timestamp_stat.mtime.sec < source_stat.mtime.sec then
        needs_update = true
        break
      end
    end
  end

  if needs_update then
    local async = require('ts-install.async')
    async.run(function()
      async.await(3, require('ts-install.install').update)
      local util = require('ts-install.util')
      util.mkpath(config.install_dir)
      util.write_file(timestamp_path, '')
    end)
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
    require('ts-install.install').install(config.ensure_install, { _auto = true })
  end

  if config.auto_update then
    local nvim_ts_path = vim.api.nvim_get_runtime_file('lua/nvim-treesitter/parsers.lua', true)[1]
    if not nvim_ts_path then
      vim.notify('nvim-treesitter is not installed', vim.log.levels.ERROR)
    end
    do_auto_update({ nvim_ts_path })
  end
end

return M
