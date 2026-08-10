local M = {}

--- Restore a backup if the installed path is missing, otherwise remove it.
--- @param backup string
--- @param installed string
local function recover_backup(backup, installed)
  if vim.uv.fs_stat(installed) then
    if vim.fn.delete(backup, 'rf') ~= 0 then
      vim.notify(('Could not remove backup %s'):format(backup), vim.log.levels.ERROR)
    end
    return
  end

  local ok, err = vim.uv.fs_rename(backup, installed)
  if not ok then
    vim.notify(('Could not restore backup %s: %s'):format(backup, err), vim.log.levels.ERROR)
  end
end

--- Recover parser and query backups left by a forced exit.
--- @param install_dir string
local function recover_backups(install_dir)
  if vim.uv.fs_stat(install_dir) then
    for name in vim.fs.dir(install_dir) do
      local lang = name:match('^%.ts%-install%.(.+)%.parser%.old$')
      local installed = lang and vim.fs.joinpath(install_dir, 'parser', lang .. '.so')
      if not lang then
        lang = name:match('^%.ts%-install%.(.+)%.queries%.old$')
        installed = lang and vim.fs.joinpath(install_dir, 'queries', lang)
      end
      if lang then
        recover_backup(vim.fs.joinpath(install_dir, name), assert(installed))
      end
    end
  end
end

local function setup_auto_install()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf = args.buf
      local ft = vim.bo[buf].filetype
      local lang = vim.treesitter.language.get_lang(ft) or ft
      if lang == '' then
        return
      end
      local async = require('ts-install.async')

      async
        .run(require('ts-install.install').install, lang, { _auto = true })
        :wait(function(err, did_install)
          assert(not err, err)
          if not did_install then
            return
          end
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) then
              -- Retrigger FileType event to start treesitter.
              vim.bo[buf].filetype = vim.bo[buf].filetype
            end
          end)
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
      require('ts-install.install').update()
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
  recover_backups(config.install_dir)

  -- Need to prepend install dir to runtimepath so that the parsers get priority
  -- over the ones provided by core.
  vim.opt.runtimepath:prepend(config.install_dir)

  if config.auto_install then
    setup_auto_install()
  end

  if #config.ensure_install > 0 then
    local async = require('ts-install.async')
    async.run(require('ts-install.install').install, config.ensure_install, { _auto = true })
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
