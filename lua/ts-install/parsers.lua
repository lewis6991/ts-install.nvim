local log = require('ts-install.log')
local util = require('ts-install.util')

--- @class ts_install.InstallInfo
---
--- Revision of parser
--- @field revision string
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

--- @class ts_install.ParserInfo
---
--- Information necessary to build and install the parser (empty for query-only language)
--- @field install_info? ts_install.InstallInfo
---
--- List of other languages to install (e.g., if queries inherit from them)
--- @field requires? string[]

local M = {}

local function get_config()
  return require('ts-install.config').config
end

local nvim_ts_url = 'https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/main'
local parsers_url = nvim_ts_url..'/lua/nvim-treesitter/parsers.lua'
local queries_url = nvim_ts_url..'/queries'

local stddata = vim.fn.stdpath('data') --[[@as string]]
local parsers_local_path = vim.fs.joinpath(stddata, 'ts-install', 'parsers.lua')
local queries_local_path = vim.fs.joinpath(stddata, 'ts-install', 'queries')

--- @type table<string,ts_install.ParserInfo>?
local parsers

local logger = log.new('parsers')

---@param retry? true
local function get_parser_info(retry)
  if parsers then
    return parsers
  end

  local config_parsers = get_config().parsers
  if config_parsers then
    return config_parsers()
  end

  if not vim.uv.fs_stat(parsers_local_path) then
    logger:debug('Downloading %s', parsers_url)
    -- REVISIT lewrus01 (14/08/24): Make async
    vim.system({
      'curl', '--silent',
      '--show-error',
      parsers_url,
      '--output',
      parsers_local_path
    }):wait()
    vim.system({
      'curl', '--silent',
      '--show-error',
      queries_url,
      '--output',
      queries_local_path
    }):wait()
  end

  -- Can't use loadfile() with an empty function environment because of
  -- vim.loader
  local code = util.read_file(parsers_local_path)
  local f = assert(loadstring(code, parsers_local_path))
  local sandboxed_f = setfenv(f, {})

  --- @diagnostic disable-next-line:no-unknown
  local ok, err_or_parsers = pcall(sandboxed_f)

  if not ok then
    logger:debug('Failed loading %s: %s', parsers_local_path, err_or_parsers)
    logger:debug('Deleting %s', parsers_local_path)
    util.delete(parsers_local_path)
    if not retry then
      logger:debug('Retrying')
      return get_parser_info(true)
    end
    logger:error('Failed to get parser information')
    return {}
  end

  --- @type table<string,ts_install.ParserInfo>
  parsers = err_or_parsers

  return parsers
end

function M.update()
  local parsers_backup = parsers
  parsers = nil

  -- loadfile(vim.api.nvim_get_runtime_file('lua/nvim-treesitter/parsers.lua', false))
  -- require('nvim-treesitter/parsers.lua')


  local old_parser_path = parsers_local_path .. '.old'
  vim.uv.fs_rename(parsers_local_path, old_parser_path)

  local ok, err = pcall(get_parser_info)
  if not ok then
    logger:error('Failed to update parsers: %s', err)
    -- Restore previous parser information
    util.delete(parsers_local_path)
    vim.uv.fs_rename(old_parser_path, parsers_local_path)
    parsers = parsers_backup
  else
    logger:info('Updated parsers')
  end
end

function M.get_parser_info()
  return get_parser_info()
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
    local ignored = get_config().ignore_install
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
function M.dir(dir_name)
  local dir = vim.fs.joinpath(get_config().install_dir, dir_name)

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
  local install_dir = M.dir('queries')

  local installed = {} --- @type string[]
  for f in vim.fs.dir(install_dir) do
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
  return vim.fs.joinpath(M.dir('parser-info'), lang .. '.revision.txt')
end

--- @param lang string
--- @return string
function M.parser_file(lang)
  return vim.fs.joinpath(M.dir('parser'), lang) .. '.so'
end

--- @param lang string
--- @return string
function M.queries_dir(lang)
  return vim.fs.joinpath(M.dir('queries'), lang)
end

return M
