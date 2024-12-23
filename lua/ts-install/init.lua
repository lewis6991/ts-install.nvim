local M = {}

local function setup_auto_install()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local parsers = require('ts-install.parsers')
      local buf = args.buf --- @type integer
      local ft = vim.bo[buf].filetype
      local lang = vim.treesitter.language.get_lang(ft) or ft
      local to_install = parsers.norm_languages(lang, { installed = true, ignored = true })
      if #to_install > 0 then
        require('ts-install.install').install(to_install, nil, function()
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
  local to_install = parsers.norm_languages(langs, { ignored = true, installed = true })

  if #to_install > 0 then
    require('ts-install.install').install(to_install, { force = true })
  end
end

--- @param sources string[]
local function do_auto_update(sources)
  local stddata = vim.fn.stdpath('data') --[[@as string]]
  local timestamp_path = vim.fs.joinpath(stddata, 'ts-install', 'update_timestamp')
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
    require('ts-install.install').update()
    require('ts-install.util').write_file(timestamp_path, '')
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

  if config.auto_update then
    local nvim_ts_path = vim.api.nvim_get_runtime_file('lua/nvim-treesitter/parsers.lua', true)[1]
    if not nvim_ts_path then
      vim.notify('nvim-treesitter is not installed', vim.log.levels.ERROR)
    end
    do_auto_update({ nvim_ts_path })
  end
end

return M
