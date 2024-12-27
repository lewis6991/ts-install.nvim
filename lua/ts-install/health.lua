local config = require('ts-install.config').config
local parsers = require('ts-install.parsers')
local util = require('ts-install.util')
local health = vim.health

local M = {}

local NVIM_TREESITTER_MINIMUM_ABI = 13
local TREE_SITTER_MIN_VER = { 0, 22, 6 }

--- @param name string
--- @return {path:string,version:string,out:string}?
local function check_exe(name)
  if vim.fn.executable(name) == 0 then
    return
  end
  local out = vim.trim(vim.fn.system({ name, '--version' }))
  return {
    path = vim.fn.exepath(name),
    version = vim.version.parse(out),
  }
end

local function install_health()
  health.start('Requirements')

  if vim.fn.has('nvim-0.10') ~= 1 then
    health.error('ts-install.nvim requires the latest Neovim 0.10')
  end

  if vim.treesitter.language_version then
    local msg = ('Neovim was compiled with tree-sitter runtime ABI version %s (required >=%s).'):format(
      vim.treesitter.language_version,
      NVIM_TREESITTER_MINIMUM_ABI
    )
    if vim.treesitter.language_version >= NVIM_TREESITTER_MINIMUM_ABI then
      health.ok(msg)
    else
      health.error(table.concat({
        msg,
        'Please make sure that Neovim is linked against a recent tree-sitter library when building',
        ' or raise an issue at your Neovim packager. Parsers must be compatible with runtime ABI.',
      }))
    end
  end

  -- treesitter check
  local ts = check_exe('tree-sitter')
  if not ts then
    health.error('tree-sitter CLI not found')
  elseif vim.version.lt(ts.version, TREE_SITTER_MIN_VER) then
    health.error(('tree-sitter CLI v%d.%d.%d is required'):format(unpack(TREE_SITTER_MIN_VER)))
  else
    health.ok(('tree-sitter %s (%s)'):format(ts.version, ts.path))
  end

  local curl = check_exe('curl')
  if curl then
    health.ok(('curl %s (%s)'):format(curl.version, curl.path))
  else
    health.error('curl not found')
  end

  local tar = check_exe('tar')
  if tar then
    health.ok(('tar %s (%s)'):format(tar.version, tar.path))
  else
    health.error('tar not found')
  end

  local git = check_exe('git')
  if git then
    health.ok(('git %s (%s)'):format(git.version, git.path))
  else
    health.error('git not found')
  end
end

local function config_health()
  health.start('Install directory for parsers and queries')
  if vim.uv.fs_access(config.install_dir, 'w') then
    health.ok(('%s is writable.'):format(config.install_dir))
  else
    health.error(('%s not writable.'):format(config.install_dir))
  end
end

local function parser_health()
  --- @type [string, string, string][]
  local error_collection = {}

  -- Parser installation checks
  health.start('Installed languages     Revision  H L F I J')
  local parser_info = parsers.get_parser_info()
  local languages = parsers.installed()
  local out = {} --- @type string[]
  for _, lang in pairs(languages) do
    local parser = parser_info[lang]
    out[#out + 1] = ('%-22s'):format(lang)

    local rok, revision_file = pcall(util.read_file, parsers.revision_file(lang))
    if not rok then
      table.insert(error_collection, { lang, 'revision', revision_file })
      out[#out + 1] = ('%8s'):format('???')
    else
      out[#out + 1] = ('%8s'):format(revision_file:sub(1, 8))
    end
    out[#out + 1] = '  '

    for _, query_group in ipairs({ 'highlights', 'locals', 'folds', 'indents', 'injections' }) do
      local qok, err = pcall(vim.treesitter.query.get, lang, query_group)
      local status = not qok and 'x' or not err and ' ' or '✓'
      out[#out + 1] = status
      out[#out + 1] = ' '
      if not qok and err then
        table.insert(error_collection, { lang, query_group, err })
      end
    end

    for _, p in pairs(parser.requires or {}) do
      if not vim.list_contains(languages, p) then
        table.insert(error_collection, { lang, 'queries', ('dependency %s missing'):format(p) })
      end
    end

    out[#out + 1] = '\n'
  end

  health.info(
    ('%s\nLegend: (H)ighlight, (L)ocals, (F)olds, (I)ndents, In(J)ections'):format(
      table.concat(out)
    )
  )

  if #error_collection > 0 then
    health.start('The following errors have been detected in query files:')
    for _, p in ipairs(error_collection) do
      local lang, type = p[1], p[2]
      local lines = {}
      table.insert(lines, ('%s(%s): '):format(lang, type))
      for _, file in ipairs(vim.treesitter.query.get_files(lang, type) or {}) do
        local query = util.read_file(file)
        local _, file_err = pcall(vim.treesitter.query.parse, lang, query)
        if file_err then
          table.insert(lines, file)
        end
      end
      health.error(table.concat(lines, ''))
    end
  end
end

function M.check()
  install_health()
  config_health()
  parser_health()
end

return M
