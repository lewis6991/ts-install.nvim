local config = require('ts-install.config').config
local parsers = require('ts-install.parsers')
local util = require('ts-install.util')
local health = vim.health

local M = {}

local NVIM_TREESITTER_MINIMUM_ABI = 13
local TREE_SITTER_MIN_VER = { 0, 22, 6 }

---@param name string
---@return table?
local function check_exe(name)
  if vim.fn.executable(name) then
    local path = vim.fn.exepath(name)
    local out = vim.trim(vim.fn.system({ name, '--version' }))
    local version = vim.version.parse(out)
    return { path = path, version = version, out = out }
  end
end

local function install_health()
  health.start('Requirements')

  do -- nvim check
    if vim.fn.has('nvim-0.10') ~= 1 then
      health.error('ts-install.nvim requires the latest Neovim 0.10')
    end

    if vim.treesitter.language_version then
      if vim.treesitter.language_version >= NVIM_TREESITTER_MINIMUM_ABI then
        health.ok(
          string.format(
            'Neovim was compiled with tree-sitter runtime ABI version %s (required >=%s).',
            vim.treesitter.language_version,
            NVIM_TREESITTER_MINIMUM_ABI
          )
        )
      else
        health.error(table.concat({
          string.format(
            'Neovim was compiled with tree-sitter runtime ABI version %s.\n',
            vim.tree_sitter.language_version
          ),
          string.format(
            'ts-install.nvim expects at least ABI version %s\n',
            NVIM_TREESITTER_MINIMUM_ABI
          ),
          'Please make sure that Neovim is linked against a recent tree-sitter library when building',
          ' or raise an issue at your Neovim packager. Parsers must be compatible with runtime ABI.',
        }))
      end
    end
  end

  do -- treesitter check
    local ts = check_exe('tree-sitter')
    if ts then
      if vim.version.ge(ts.version, TREE_SITTER_MIN_VER) then
        health.ok(string.format('tree-sitter %s (%s)', ts.version, ts.path))
      else
        health.error(
          string.format('tree-sitter CLI v%d.%d.%d is required', unpack(TREE_SITTER_MIN_VER))
        )
      end
    else
      health.error('tree-sitter CLI not found')
    end
  end

  do -- curl+tar check
    local curl = check_exe('curl')
    if curl then
      health.ok(string.format('curl %s (%s)\n%s', curl.version, curl.path, curl.out))
    else
      health.error('curl not found')
    end

    local tar = check_exe('tar')
    if tar then
      health.ok(string.format('tar %s (%s)', tar.version, tar.path))
    else
      health.error('tar not found')
    end
  end

  health.start('OS Info')
  for k, v in
    pairs(vim.uv.os_uname() --[[@as table<string,string>]])
  do
    health.info(k .. ': ' .. v)
  end

  local installdir = config.install_dir
  health.start('Install directory for parsers and queries')
  health.info(installdir)
  if vim.uv.fs_access(installdir, 'w') then
    health.ok('is writable.')
  else
    health.error('is not writable.')
  end
  if
    vim.iter(vim.api.nvim_list_runtime_paths()):any(function(p)
      return installdir == vim.fs.normalize(p) .. '/'
    end)
  then
    health.ok('is in runtimepath.')
  else
    health.error('is not in runtimepath.')
  end
end

local function query_status(lang, query_group)
  local ok, err = pcall(vim.treesitter.query.get, lang, query_group)
  if not ok then
    return 'x', err
  elseif not err then
    return '.'
  end
  return '✓'
end

function M.check()
  --- @type {[1]: string, [2]: string, [3]: string}[]
  local error_collection = {}
  -- Installation dependency checks
  install_health()

  -- Parser installation checks
  health.start('Installed languages' .. string.rep(' ', 5) .. 'H L F I J')
  local parser_info = parsers.get_parser_info()
  local languages = parsers.installed()
  for _, lang in pairs(languages) do
    local parser = parser_info[lang]
    local out = lang .. string.rep(' ', 22 - #lang)
    if parser.install_info then
      for _, query_group in pairs(M.bundled_queries) do
        local status, err = query_status(lang, query_group)
        --- @type string
        out = out .. status .. ' '
        if err then
          table.insert(error_collection, { lang, query_group, err })
        end
      end
    end
    if parser.requires then
      for _, p in pairs(parser.requires) do
        if not vim.list_contains(languages, p) then
          table.insert(error_collection, { lang, 'queries', 'dependency ' .. p .. ' missing' })
        end
      end
    end
    health.info(vim.fn.trim(out, ' ', 2))
  end
  health.start('  Legend: H[ighlight], L[ocals], F[olds], I[ndents], In[J]ections')

  if #error_collection > 0 then
    health.start('The following errors have been detected in query files:')
    for _, p in ipairs(error_collection) do
      local lang, type = p[1], p[2]
      local lines = {}
      table.insert(lines, lang .. '(' .. type .. '): ')
      local files = vim.treesitter.query.get_files(lang, type)
      if #files > 0 then
        for _, file in ipairs(files) do
          local query = util.read_file(file)
          local _, file_err = pcall(vim.treesitter.query.parse, lang, query)
          if file_err then
            table.insert(lines, file)
          end
        end
      end
      health.error(table.concat(lines, ''))
    end
  end
end

M.bundled_queries = { 'highlights', 'locals', 'folds', 'indents', 'injections' }

return M
