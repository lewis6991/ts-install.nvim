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

--- @async
--- @param cmd string[]
--- @param opts? vim.SystemOpts
--- @return vim.SystemCompleted
local function system(cmd, opts)
  local cwd = opts and opts.cwd or uv.cwd()
  log.trace('running job: (cwd=%s) %s', cwd, table.concat(cmd, ' '))
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

--- @param lang string
--- @return boolean
local function needs_update(lang)
  local info = parsers.install_info(lang)
  if info and info.revision then
    return info.revision ~= util.read_file(parsers.revision_file(lang))
  end

  -- No revision. Check the queries link to the same place

  local queries = parsers.queries_dir(lang)
  local queries_src = parsers.queries_src_dir(lang)

  return uv.fs_realpath(queries) ~= uv.fs_realpath(queries_src)
end

--- @async
--- @param path string
--- @param mode? string
--- @return string? err
local function mkpath(path, mode)
  local parent = fs.dirname(path)
  if not parent:match('^[./]$') and not uv.fs_stat(parent) then
    mkpath(parent, mode)
  end

  return uv_mkdir(path, tonumber(mode or '755', 8))
end

--- @async
--- @param logger ts_install.Logger
--- @param lang string
--- @param output_dir string
--- @return string? err
local function download_parser(logger, lang, output_dir)
  local tmp = output_dir .. '-tmp'
  util.delete(tmp)

  local tarball_path = fs.joinpath(output_dir .. '.tar.gz')

  do -- Download tarball
    local target = parsers.tarball_url(lang)
    logger:info('Downloading %s...', target)
    local r = system({
      'curl',
      '--silent',
      '--fail',
      '--show-error',
      '-L', -- follow redirects
      target,
      '--output',
      tarball_path,
    })
    if r.code > 0 then
      return logger:error('Could not download %s: %s', tarball_path, r.stderr)
    end
  end

  do -- Create tmp dir
    logger:debug('Creating temporary directory: %s', tmp)
    local err = mkpath(tmp)
    async.main()
    if err then
      return logger:error('Could not create %s: %s', tmp, err)
    end
  end

  do -- Extract tarball
    logger:debug('Extracting %s into %s...', tarball_path, tmp)
    local r = system({ 'tar', '-xzf', tarball_path, '-C', tmp })
    if r.code > 0 then
      return logger:error('Error during tarball extraction: %s', r.stderr)
    end
  end

  do -- Remove tarball
    logger:info('Removing %s...', tarball_path)
    local err = uv_unlink(tarball_path)
    async.main()
    if err then
      return logger:error('Could not remove tarball: %s', err)
    end
  end

  do -- Move tmp dir to output dir
    local ref = parsers.ref(lang)
    local dir_rev = ref:find('^v%d') and ref:sub(2) or ref
    local extracted = fs.joinpath(tmp, parsers.project_name(lang) .. '-' .. dir_rev)
    logger:info('Moving %s to %s/...', extracted, output_dir)
    local err = uv_rename(extracted, output_dir)
    async.main()
    if err then
      return logger:error('Could not rename temp: %s', err)
    end
  end

  -- REVISIT lewrus01 (14/08/24): Make async
  util.delete(tmp)
end

--- @async
--- @param lang string
--- @param info ts_install.InstallInfo
--- @param logger ts_install.Logger
--- @param generate? boolean
--- @return string? err
local function install_parser(lang, info, logger, generate)
  if not info.path and not info.url then
    return log.error('No url or path for %s', lang)
  end

  local src_dir = parsers.src_dir(lang)

  if not info.path then
    util.delete(src_dir)
    local err = download_parser(logger, lang, src_dir)
    if err then
      return err
    end
  end

  local compile_dir = parsers.compile_dir(lang)

  -- generate parser from grammar
  if info.generate or generate then
    logger:info(
      string.format(
        'Generating parser.c from %s...',
        info.generate_from_json and 'grammar.json' or 'grammar.js'
      )
    )

    local ts_ver = tostring(vim.treesitter.language_version)
    local grammar_json = info.generate_from_json and 'src/grammar.json' or nil
    local r = system(
      { 'tree-sitter', 'generate', '--no-bindings', '--abi', ts_ver, grammar_json },
      { cwd = compile_dir }
    )
    if r.code > 0 then
      return logger:error('Error during "tree-sitter generate": %s', r.stderr)
    end
  end

  do -- compile parser
    logger:info('Compiling parser')
    local r = system({ 'tree-sitter', 'build', '-o', 'parser.so' }, { cwd = compile_dir })
    if r.code > 0 then
      return logger:error('Error during "tree-sitter build": %s', r.stderr)
    end
  end

  do -- install parser
    logger:info('Installing parser')
    local install_path = parsers.parser_file(lang)

    if uv.os_uname().sysname == 'Windows_NT' then -- why can't you just be normal?!
      local tempfile = install_path .. tostring(uv.hrtime())
      uv_rename(install_path, tempfile) -- parser may be in use: rename...
      uv_unlink(tempfile) -- ...and mark for garbage collection
    end

    local parser_lib_name = fs.joinpath(compile_dir, 'parser.so')
    local err = uv_copyfile(parser_lib_name, install_path)
    async.main()
    if err then
      return logger:error('Error during parser installation: %s', err)
    end
  end

  if not info.path then
    -- TODO(lewis6991): ref could be a branch which is not a trackable revision
    -- Use git ls-remote to get the commit hash
    local ref = parsers.ref(lang)
    util.write_file(parsers.revision_file(lang), ref or '')
    util.delete(src_dir)
  end
end

--- @async
--- @param lang string
--- @param generate? boolean
--- @return string? err
local function install_lang(lang, generate)
  local logger = log.new('install/' .. lang)

  local install_info = parsers.install_info(lang)
  if install_info then
    local err = install_parser(lang, install_info, logger, generate)
    if err then
      return err
    end
  end

  do -- install queries
    local queries_src = parsers.queries_src_dir(lang)
    local queries = parsers.queries_dir(lang)
    uv_unlink(queries)
    local err = uv_symlink(queries_src, queries, { dir = true, junction = true })
    async.main()
    if err then
      return logger:error(err)
    end
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

--- @async
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
    tasks[#tasks + 1] = async.create(0, function()
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
--- @param _callback? fun()
M.install = async.create(2, function(languages, options, _callback)
  parsers.reload()
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
M.update = async.create(2, function(languages, _options, _callback)
  parsers.reload()
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

--- @async
--- @param logger ts_install.Logger
--- @param lang string
--- @return string? err
local function uninstall_lang(logger, lang)
  logger:debug('Uninstalling %s', lang)
  install_status[lang] = nil

  local had_err = false
  for _, d in ipairs({
    parsers.parser_file(lang),
    parsers.revision_file(lang),
    parsers.queries_dir(lang),
  }) do
    if vim.uv.fs_stat(d) then
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
M.uninstall = async.create(2, function(languages, _options, _callback)
  languages = parsers.norm_languages(languages or 'all', { missing = true, dependencies = true })

  local installed = parsers.installed()

  local tasks = {} --- @type fun()[]
  local done = 0
  for _, lang in ipairs(languages) do
    local logger = log.new('uninstall/' .. lang)
    if not vim.list_contains(installed, lang) then
      log.warn('Parser for ' .. lang .. ' is is not managed by ts')
    else
      tasks[#tasks + 1] = async.create(0, function()
        local err = uninstall_lang(logger, lang)
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
