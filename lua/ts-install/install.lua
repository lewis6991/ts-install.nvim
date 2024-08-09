local fn = vim.fn
local fs = vim.fs
local uv = vim.uv

local async = require('ts-install.async')
local log = require('ts-install.log')
local util = require('ts-install.util')
local parsers = require('ts-install.parsers')

--- @type fun(path: string, new_path: string, flags?: table): string?
local uv_copyfile = async.wrap(4, uv.fs_copyfile)

--- @type fun(path: string, mode: integer): string?
local uv_mkdir = async.wrap(3, uv.fs_mkdir)

--- @type fun(path: string, new_path: string): string?
local uv_rename = async.wrap(3, uv.fs_rename)

--- @type fun(path: string, new_path: string, flags?: table): string?
local uv_symlink = async.wrap(4, uv.fs_symlink)

--- @type fun(path: string): string?
local uv_unlink = async.wrap(2, uv.fs_unlink)

local max_jobs = 10

--- @param cmd string[]
--- @param opts vim.SystemOpts
--- @return vim.SystemCompleted
local function system(cmd, opts)
  log.trace('running job: (cwd=%s) %s', opts.cwd, table.concat(cmd, ' '))
  local r = async.wrap(3, vim.system)(cmd, opts) --[[@as vim.SystemCompleted]]
  async.main()
  if r.stdout and r.stdout ~= '' then
    log.trace('stdout -> %s', r.stdout)
  end
  if r.stderr and r.stderr ~= '' then
    log.trace('stderr -> %s', r.stderr)
  end

  return r
end

local M = {}

local nvim_treesitter_dir --- @type string

--- @param ... string
--- @return string
function M.get_package_path(...)
  if not nvim_treesitter_dir then
    local runtime_dirs = vim.api.nvim_get_runtime_file('runtime', true)
    for _, dir in ipairs(runtime_dirs) do
      if dir:match('/nvim%-treesitter/') then
        nvim_treesitter_dir = vim.fs.dirname(dir)
        break
      end
    end
  end

  if not nvim_treesitter_dir then
    error('nvim-treesitter is not installed')
  end

  return fs.joinpath(nvim_treesitter_dir, ...)
end

--- @param lang string
--- @return boolean
local function needs_update(lang)
  local info = parsers.install_info(lang)
  if info and info.revision then
    return info.revision ~= parsers.installed_revision(lang)
  end

  -- No revision. Check the queries link to the same place

  local queries = fs.joinpath(parsers.dir('queries'), lang)
  local queries_src = M.get_package_path('runtime', 'queries', lang)

  return uv.fs_realpath(queries) ~= uv.fs_realpath(queries_src)
end

---
--- PARSER MANAGEMENT FUNCTIONS
---

--- @param logger ts_install.Logger
--- @param repo ts_install.InstallInfo
--- @param compile_location string
--- @return string? err
local function do_generate(logger, repo, compile_location)
  logger:info(
    string.format(
      'Generating parser.c from %s...',
      repo.generate_from_json and 'grammar.json' or 'grammar.js'
    )
  )

  local r = system({
    'tree-sitter',
    'generate',
    '--no-bindings',
    '--abi',
    tostring(vim.treesitter.language_version),
    repo.generate_from_json and 'src/grammar.json' or nil,
  }, { cwd = compile_location })
  if r.code > 0 then
    return logger:error('Error during "tree-sitter generate": %s', r.stderr)
  end
end

--- @param logger ts_install.Logger
--- @param repo ts_install.InstallInfo
--- @param project_name string
--- @param cache_dir string
--- @param revision string
--- @param project_dir string
--- @return string? err
local function do_download(logger, repo, project_name, cache_dir, revision, project_dir)
  local is_gitlab = repo.url:find('gitlab.com', 1, true)
  local url = repo.url:gsub('.git$', '')

  local dir_rev = revision
  if revision:find('^v%d') then
    dir_rev = revision:sub(2)
  end

  local temp_dir = project_dir .. '-tmp'

  util.delete(temp_dir)

  logger:info('Downloading %s...',  project_name)
  local target = is_gitlab
      and string.format('%s/-/archive/%s/%s-%s.tar.gz', url, revision, project_name, revision)
    or string.format('%s/archive/%s.tar.gz', url, revision)

  do
    local r = system({
      'curl',
      '--silent',
      '--show-error',
      '-L', -- follow redirects
      target,
      '--output',
      project_name .. '.tar.gz',
    }, {
      cwd = cache_dir,
    })
    if r.code > 0 then
      return logger:error('Error during download: %s', r.stderr)
    end
  end

  logger:debug('Creating temporary directory: %s', temp_dir)

  do
    --TODO(clason): use fn.mkdir(temp_dir, 'p') in case stdpath('cache') is not created
    local err = uv_mkdir(temp_dir, tonumber('755', 8))
    async.main()
    if err then
      return logger:error('Could not create %s-tmp: %s', project_name, err)
    end
  end

  logger:info('Extracting %s...', project_name)
  do
    local r = system({
      'tar',
      '-xzf',
      project_name .. '.tar.gz',
      '-C',
      project_name .. '-tmp',
    }, {
      cwd = cache_dir,
    })
    if r.code > 0 then
      return logger:error('Error during tarball extraction: %s', r.stderr)
    end
  end

  do
    local err = uv_unlink(project_dir .. '.tar.gz')
    async.main()
    if err then
      return logger:error('Could not remove tarball: %s', err)
    end
  end

  do
    local err = uv_rename(fs.joinpath(temp_dir, url:match('[^/]-$') .. '-' .. dir_rev), project_dir)
    async.main()
    if err then
      return logger:error('Could not rename temp: %s', err)
    end
  end

  util.delete(temp_dir)
end

--- @param logger ts_install.Logger
--- @param compile_location string
--- @return string? err
local function do_compile(logger, compile_location)
  logger:info(string.format('Compiling parser'))

  local r = system({
    'tree-sitter',
    'build',
    '-o',
    'parser.so',
  }, { cwd = compile_location })
  if r.code > 0 then
    return logger:error('Error during "tree-sitter build": %s', r.stderr)
  end
end

--- @param logger ts_install.Logger
--- @param compile_location string
--- @param target_location string
--- @return string? err
local function do_install(logger, compile_location, target_location)
  logger:info(string.format('Installing parser'))

  if uv.os_uname().sysname == 'Windows_NT' then -- why can't you just be normal?!
    local tempfile = target_location .. tostring(uv.hrtime())
    uv_rename(target_location, tempfile) -- parser may be in use: rename...
    uv_unlink(tempfile) -- ...and mark for garbage collection
  end

  local err = uv_copyfile(compile_location, target_location)
  async.main()
  if err then
    return logger:error('Error during parser installation: %s', err)
  end
end

--- @param lang string
--- @param info ts_install.InstallInfo
--- @param logger ts_install.Logger
--- @param generate? boolean
--- @return string? err
local function install_parser(lang, info, logger, generate)
  local cache_dir = vim.fs.normalize(fn.stdpath('cache') --[[@as string]])
  local install_dir = parsers.dir('parser')

  local project_name = 'tree-sitter-' .. lang

  local revision = info.revision

  local compile_location --- @type string
  if info.path then
    compile_location = fs.normalize(info.path)
  else
    local project_dir = fs.joinpath(cache_dir, project_name)
    util.delete(project_dir)

    revision = revision or info.branch or 'main'

    local err = do_download(logger, info, project_name, cache_dir, revision, project_dir)
    if err then
      return err
    end
    compile_location = fs.joinpath(cache_dir, project_name)
  end

  if info.location then
    compile_location = fs.joinpath(compile_location, info.location)
  end

  do -- generate parser from grammar
    if info.generate or generate then
      local err = do_generate(logger, info, compile_location)
      if err then
        return err
      end
    end
  end

  do -- compile parser
    local err = do_compile(logger, compile_location)
    if err then
      return err
    end
  end

  do -- install parser
    local parser_lib_name = fs.joinpath(compile_location, 'parser.so')
    local install_location = fs.joinpath(install_dir, lang) .. '.so'
    local err = do_install(logger, parser_lib_name, install_location)
    if err then
      return err
    end

    parsers.update_installed_revision(lang, revision)
  end

  if not info.path then
    util.delete(fs.joinpath(cache_dir, project_name))
  end
end

--- @param lang string
--- @param generate? boolean
--- @return string? err
local function install_lang(lang, generate)
  local logger = log.new('install/' .. lang)

  local parser_install_info = parsers.install_info(lang)
  if parser_install_info then
    local err = install_parser(lang, parser_install_info, logger, generate)
    if err then
      return err
    end
  end

  local queries = fs.joinpath(parsers.dir('queries'), lang)
  local queries_src = M.get_package_path('runtime', 'queries', lang)
  uv_unlink(queries)
  local err = uv_symlink(queries_src, queries, { dir = true, junction = true })
  async.main()
  if err then
    return logger:error(err)
  end
  logger:info('Language installed')
end

--- @alias ts_install.install.Status
--- | 'installing'
--- | 'installed'
--- | 'failed'
--- | 'timeout'

local install_status = {} --- @type table<string,ts_install.install.Status?>

local INSTALL_TIMEOUT = 60000

--- @param lang string
--- @param force? boolean
--- @param generate? boolean
--- @return ts_install.install.Status status
local function try_install_lang(lang, force, generate)
  if not force and vim.list_contains(parsers.installed(), lang) then
    local yesno = fn.input(lang .. ' parser already available: would you like to reinstall ? y/n: ')
    print('\n ')
    if yesno:sub(1, 1) ~= 'y' then
      install_status[lang] = 'installed'
      return 'installed'
    end
  end

  if install_status[lang] then
    if install_status[lang] == 'installing' then
      vim.wait(INSTALL_TIMEOUT, function()
        return install_status[lang] ~= 'installing'
      end)
      install_status[lang] = 'timeout'
    end
  else
    install_status[lang] = 'installing'
    local err = install_lang(lang, generate)
    install_status[lang] = err and 'failed' or 'installed'
  end

  local status = install_status[lang]
  assert(status and status ~= 'installing')
  return status
end

--- Reload the parser table and user modifications in case of update
local function reload_parsers()
  --- @diagnostic disable-next-line:no-unknown
  package.loaded['nvim-treesitter.parsers'] = nil
end

--- @class ts_install.install.InstallOpts
--- @field force? boolean
--- @field generate? boolean
--- @field skip? table

--- Install a parser
--- @param languages string[]
--- @param options? ts_install.install.InstallOpts
--- @param _callback? fun()
local function install(languages, options, _callback)
  options = options or {}

  local tasks = {} --- @type fun()[]
  local done = 0
  for _, lang in ipairs(languages) do
    tasks[#tasks + 1] = async.sync(0, function()
      async.main()
      local status = try_install_lang(lang, options.force, options.generate)
      if status ~= 'failed' then
        done = done + 1
      end
    end)
  end

  async.join(max_jobs, nil, tasks)
  if #tasks > 1 then
    async.main()
    log.info('Installed %d/%d languages', done, #tasks)
  end
end

--- @param languages string[]|string
--- @param options? ts_install.install.InstallOpts
M.install = async.sync(2, function(languages, options, _callback)
  reload_parsers()
  if not languages or #languages == 0 then
    languages = 'all'
  end

  languages = parsers.norm_languages(languages, options and options.skip)

  if languages[1] == 'all' then
    options.force = true
  end

  install(languages, options)
end)

--- @class ts_install.install.UpdateOpts

--- @param languages? string[]|string
--- @param _options? ts_install.install.UpdateOpts
--- @param _callback? function
M.update = async.sync(2, function(languages, _options, _callback)
  reload_parsers()
  if not languages or #languages == 0 then
    languages = 'all'
  end
  languages = parsers.norm_languages(languages, { ignored = true, missing = true })
  languages = vim.tbl_filter(needs_update, languages) --- @type string[]

  if #languages > 0 then
    install(languages, { force = true })
  else
    log.info('All parsers are up-to-date')
  end
end)

--- @param logger ts_install.Logger
--- @param lang string
--- @param parser string
--- @param queries string
--- @return string? err
local function uninstall_lang(logger, lang, parser, queries)
  logger:debug('Uninstalling %s', lang)
  install_status[lang] = nil

  local had_err = false
  for _, d in ipairs { parser, queries } do
    if vim.fn.filereadable(d) == 1 then
      logger:debug('Unlinking %s', d)
      local err = uv_unlink(d)
      async.main()
      if err then
        logger:error(err)
        had_err = true
      end
    end
  end

  logger:info('Language uninstalled%s', had_err and ' (with errors, see ":TS log")' or '')
end

--- @param languages string[]|string
--- @param _options? ts_install.install.UpdateOpts
--- @param _callback? fun()
M.uninstall = async.sync(2, function(languages, _options, _callback)
  languages = parsers.norm_languages(languages or 'all', { missing = true, dependencies = true })

  local parser_dir = parsers.dir('parser')
  local query_dir = parsers.dir('queries')
  local installed = parsers.installed()

  local tasks = {} --- @type fun()[]
  local done = 0
  for _, lang in ipairs(languages) do
    local logger = log.new('uninstall/' .. lang)
    if not vim.list_contains(installed, lang) then
      log.warn('Parser for ' .. lang .. ' is is not managed by ts')
    else
      local parser = fs.joinpath(parser_dir, lang) .. '.so'
      local queries = fs.joinpath(query_dir, lang)
      tasks[#tasks + 1] = async.sync(0, function()
        local err = uninstall_lang(logger, lang, parser, queries)
        if not err then
          done = done + 1
        end
      end)
    end
  end

  async.join(max_jobs, nil, tasks)
  if #tasks > 1 then
    async.main()
    log.info('Uninstalled %d/%d languages', done, #tasks)
  end
end)

return M
