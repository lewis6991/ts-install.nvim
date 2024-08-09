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
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local buf = args.buf --- @type integer
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft) or ft
        if
          require('ts.parsers')[lang]
          and not vim.list_contains(M.installed_parsers(), lang)
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
    local to_install = M.norm_languages(config.ensure_install, { ignored = true, installed = true })

    if #to_install > 0 then
      require('ts.install').install(to_install, { force = true })
    end
  end
end

-- Returns the install path for parsers, parser info, and queries.
-- If the specified directory does not exist, it is created.
---@param dir_name string
---@return string
function M.get_install_dir(dir_name)
  local config = require('ts.config').config
  local dir = vim.fs.joinpath(config.install_dir, dir_name)

  if not vim.uv.fs_stat(dir) then
    local ok, err = pcall(vim.fn.mkdir, dir, 'p', '0755')
    if not ok then
      local log = require('ts.log')
      log.error(err --[[@as string]])
    end
  end
  return dir
end

---@return string[]
function M.installed_parsers()
  local install_dir = M.get_install_dir('queries')

  local installed = {} --- @type string[]
  for f in vim.fs.dir(install_dir) do
    installed[#installed + 1] = f
  end

  return installed
end

-- Get a list of all available parsers
---@return string[]
function M.get_available()
  local parsers = require('ts.parsers')
  --- @type string[]
  local languages = vim.tbl_keys(parsers)
  table.sort(languages)
  return languages
end

---Normalize languages
---@param languages? string[]|string
---@param skip? { ignored?: boolean, missing?: boolean, installed?: boolean, dependencies?: boolean }
---@return string[]
function M.norm_languages(languages, skip)
  if not languages then
    return {}
  elseif type(languages) == 'string' then
    languages = { languages }
  end

  skip = skip or {}

  if vim.list_contains(languages, 'all') then
    if skip.missing then
      return M.installed_parsers()
    end
    languages = M.get_available()
  end

  if skip.ignored then
    local config = require('ts.config').config
    local ignored = config.ignore_install
    languages = vim.tbl_filter(
      --- @param v string
      function(v)
        return not vim.list_contains(ignored, v)
      end,
      languages
    )
  end

  if skip.installed then
    local installed = M.installed_parsers()
    languages = vim.tbl_filter(
      --- @param v string
      function(v)
        return not vim.list_contains(installed, v)
      end,
      languages
    )
  end

  if skip.missing then
    local installed = M.installed_parsers()
    languages = vim.tbl_filter(
      --- @param v string
      function(v)
        return vim.list_contains(installed, v)
      end,
      languages
    )
  end

  local parsers = require('ts.parsers')
  languages = vim.tbl_filter(
    --- @param v string
    function(v)
      -- TODO(lewis6991): warn of any unknown parsers?
      return parsers[v] ~= nil
    end,
    languages
  )

  if not skip.dependencies then
    for _, lang in pairs(languages) do
      if parsers[lang].requires then
        vim.list_extend(languages, parsers[lang].requires)
      end
    end
  end

  return languages
end

return M
