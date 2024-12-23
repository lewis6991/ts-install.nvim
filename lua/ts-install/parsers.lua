local fs = vim.fs
local log = require('ts-install.log')

--- @class ts_install.InstallInfo
---
--- Revision of parser
--- @field revision? string
---
--- URL of parser repo (Github/Gitlab)
--- @field url string
---
--- Branch of parser repo to download (if not default branch)
--- @field branch? string
---
--- Location of `grammar.js` in repo (if not at root, e.g., in a monorepo)
--- @field location? string
---
--- Repo does not contain a `parser.c`; must be generated from grammar first
--- @field generate? boolean
---
--- Parser needs to be generated from `grammar.json` (generating from `grammar.js` requires npm)
--- @field generate_from_json? boolean
---
--- Parser repo is a local directory; overrides `url`, `revision`, and `branch`
--- @field path? string
---
--- Path to query files in repo (if not at root).
--- @field queries_dir? string

--- @class ts_install.ParserInfo
---
--- Information necessary to build and install the parser (empty for query-only language)
--- @field install_info? ts_install.InstallInfo
---
--- List of other languages to install (e.g., if queries inherit from them)
--- @field requires? string[]

local nvim_treesitter_dir --- @type string

--- @return string
local function get_nvim_treesitter_dir()
  if not nvim_treesitter_dir then
    local runtime_dirs = vim.api.nvim_get_runtime_file('runtime', true)
    for _, dir in ipairs(runtime_dirs) do
      if dir:match('/nvim%-treesitter/') then
        nvim_treesitter_dir = fs.dirname(dir)
        break
      end
    end
  end

  if not nvim_treesitter_dir then
    error('nvim-treesitter is not installed')
  end

  return nvim_treesitter_dir
end

local M = {}

--- @type table<string,ts_install.ParserInfo>?
local nvim_ts_parsers

--- @return table<string,ts_install.ParserInfo>
function M.get_parser_info()
  if not nvim_ts_parsers then
    --- @type table<string,ts_install.ParserInfo>
    nvim_ts_parsers = vim.deepcopy(require('nvim-treesitter.parsers'))
    for lang, parser_info in pairs(nvim_ts_parsers) do
      parser_info.install_info = parser_info.install_info or {}
      parser_info.install_info.queries_dir =
        vim.fs.joinpath(get_nvim_treesitter_dir(), 'runtime', 'queries', lang)
    end
  end

  local config = require('ts-install.config').config

  return vim.tbl_extend('force', nvim_ts_parsers, config.parsers)
end

--- Get a list of all available parsers
--- @return string[]
function M.get_available()
  --- @type string[]
  local languages = vim.tbl_keys(M.get_parser_info())
  table.sort(languages)
  return languages
end

--- Normalize languages
--- @param languages? string[]|string
--- @param skip? { ignored?: boolean, missing?: boolean, installed?: boolean, dependencies?: boolean }
--- @return string[]
function M.norm_languages(languages, skip)
  if not languages then
    return {}
  elseif type(languages) == 'string' then
    languages = { languages }
  end

  skip = skip or {}

  if vim.list_contains(languages, 'all') then
    if skip.missing then
      return M.installed()
    end
    languages = M.get_available()
  end

  if skip.ignored then
    local config = require('ts-install.config').config
    local ignored = config.ignore_install
    languages = vim.tbl_filter(
      --- @param v string
      function(v)
        return not vim.list_contains(ignored, v)
      end,
      languages
    )
    if #languages == 0 then
      return languages
    end
  end

  local installed --- @type string[]?

  if skip.installed then
    languages = vim.tbl_filter(
      --- @param v string
      function(v)
        installed = installed or M.installed()
        return not vim.list_contains(installed, v)
      end,
      languages
    )
  end

  if skip.missing then
    languages = vim.tbl_filter(
      --- @param v string
      function(v)
        installed = installed or M.installed()
        return vim.list_contains(installed, v)
      end,
      languages
    )
  end

  if #languages == 0 then
    return languages
  end

  local parser_info = M.get_parser_info()
  languages = vim.tbl_filter(
    --- @param v string
    function(v)
      -- TODO(lewis6991): warn of any unknown parsers?
      return parser_info[v] ~= nil
    end,
    languages
  )

  if not skip.dependencies then
    for _, lang in pairs(languages) do
      if parser_info[lang].requires then
        vim.list_extend(languages, parser_info[lang].requires)
      end
    end
  end

  return languages
end

-- Returns the install path for parsers, parser info, and queries.
-- If the specified directory does not exist, it is created.
---@param dir_name string?
---@return string
local function install_dir(dir_name)
  local config = require('ts-install.config').config
  local dir = fs.joinpath(config.install_dir, dir_name)

  if not vim.uv.fs_stat(dir) then
    local ok, err = pcall(vim.fn.mkdir, dir, 'p', '0755')
    if not ok then
      log.error(err --[[@as string]])
    end
  end
  return dir
end

---@return string[]
function M.installed()
  local installed = {} --- @type string[]
  for f in fs.dir(install_dir('queries')) do
    installed[#installed + 1] = f
  end

  return installed
end

--- @param lang string
--- @return ts_install.InstallInfo?
function M.install_info(lang)
  local parser_info = M.get_parser_info()[lang]

  if not parser_info then
    log.error('Parser not available for language "' .. lang .. '"')
    return
  end

  return parser_info.install_info
end

--- @param lang string
--- @return string
function M.revision_file(lang)
  return fs.joinpath(install_dir('parser-info'), lang .. '.revision.txt')
end

--- @param lang string
--- @return string
function M.parser_file(lang)
  return fs.joinpath(install_dir('parser'), lang) .. '.so'
end

--- @param lang string
--- @return string
function M.queries_dir(lang)
  return fs.joinpath(install_dir('queries'), lang)
end

--- @param lang string
--- @return string
function M.queries_src_dir(lang)
  local install_info = M.install_info(lang)
  if install_info and install_info.queries_dir then
    return install_info.queries_dir
  end

  return fs.joinpath(M.src_dir(lang), 'queries')
end

--- @param lang string
--- @return string
function M.src_dir(lang)
  local install_info = M.install_info(lang)
  if install_info and install_info.path then
    return fs.normalize(install_info.path)
  end

  local cache_dir = fs.normalize(vim.fn.stdpath('cache') --[[@as string]])
  -- Do not use M.project_name since project_name may contain multiple parsers.
  return fs.joinpath(cache_dir, 'tree-sitter-' .. lang)
end

--- @param lang string
--- @return string
function M.compile_dir(lang)
  local install_info = M.install_info(lang)
  local src_dir = M.src_dir(lang)
  if install_info and install_info.location then
    return fs.joinpath(src_dir, install_info.location)
  end
  return src_dir
end

--- @param lang string
--- @return string
function M.project_name(lang)
  local url = assert(M.install_info(lang)).url
  url = url:gsub('.git$', '')
  return assert(url:match('[^/]-$'))
end

--- @param lang string
--- @return string
function M.tarball_url(lang)
  local revision = M.ref(lang)
  local url = assert(M.install_info(lang)).url
  local is_gitlab = url:find('gitlab.com', 1, true)
  url = url:gsub('.git$', '')
  if is_gitlab then
    return ('%s/-/archive/%s/%s-%s.tar.gz'):format(url, revision, M.project_name(lang), revision)
  end
  return ('%s/archive/%s.tar.gz'):format(url, revision)
end

--- @param lang string
--- @return string
function M.ref(lang)
  local info = assert(M.install_info(lang))
  return info.revision or info.branch or 'main'
end

--- Reload the parser table and user modifications in case of update
function M.reload()
  --- @diagnostic disable-next-line:no-unknown
  package.loaded['nvim-treesitter.parsers'] = nil
end

return M
