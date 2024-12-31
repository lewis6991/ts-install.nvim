local fs = vim.fs

local async = require('ts-install.async')
local log = require('ts-install.log')
local util = require('ts-install.util')
local parsers = require('ts-install.parsers')

local max_jobs = 10

local M = {}

--- @async
--- @param lang string
--- @return boolean
local function needs_update(lang)
  local info = parsers.install_info(lang)
  if info then
    local ok, revision_file = pcall(util.read_file, parsers.revision_file(lang))
    -- Always update if:
    -- - error reading revision file (missing)
    -- - lang has no target revision (missing url)
    -- - revision file does not match target revision
    return not ok or revision_file ~= parsers.target_revision(lang)
  end

  -- No revision. Check the queries link to the same place

  local queries = parsers.queries_dir(lang)
  local queries_src = parsers.queries_src_dir(lang)
  local err1, queries_real = util.realpath(queries)
  local err2, queries_src_real = util.realpath(queries_src)

  return not not (err1 or err2 or queries_real ~= queries_src_real)
end

--- @async
--- @param logger ts_install.Logger
--- @param lang string
--- @param output_dir string
--- @return string? err
local function download_parser(logger, lang, output_dir)
  local tmp = output_dir .. '-tmp'
  util.remove(tmp)

  local tarball_path = output_dir .. '.tar.gz'

  do -- Download tarball
    local target = parsers.tarball_url(lang)
    logger:info('Downloading %s...', target)
    local r = util.system({
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
    local err = util.mkpath(tmp)
    async.main()
    if err then
      return logger:error('Could not create %s: %s', tmp, err)
    end
  end

  do -- Extract tarball
    logger:debug('Extracting %s into %s...', tarball_path, tmp)
    local r = util.system({ 'tar', '-xzf', tarball_path, '-C', tmp })
    if r.code > 0 then
      return logger:error('Error during tarball extraction: %s', r.stderr)
    end
  end

  logger:info('Removing %s...', tarball_path)
  util.remove(tarball_path)

  do -- Move tmp dir to output dir
    local ref = parsers.ref(lang)
    local dir_rev = ref:find('^v%d') and ref:sub(2) or ref
    local extracted = fs.joinpath(tmp, parsers.project_name(lang) .. '-' .. dir_rev)
    logger:info('Moving %s to %s/...', extracted, output_dir)
    local err = util.rename(extracted, output_dir)
    async.main()
    if err then
      return logger:error('Could not rename temp: %s', err)
    end
  end

  util.remove(tmp)
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
    util.remove(src_dir)
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
    local r = util.system(
      { 'tree-sitter', 'generate', '--no-bindings', '--abi', ts_ver, grammar_json },
      { cwd = compile_dir }
    )
    if r.code > 0 then
      return logger:error('Error during "tree-sitter generate": %s', r.stderr)
    end
  end

  do -- compile parser
    logger:info('Compiling parser')
    local r = util.system({ 'tree-sitter', 'build', '-o', 'parser.so' }, { cwd = compile_dir })
    if r.code > 0 then
      return logger:error('Error during "tree-sitter build": %s', r.stderr)
    end
  end

  do -- install parser
    logger:info('Installing parser')
    local install_path = parsers.parser_file(lang)

    if vim.uv.os_uname().sysname == 'Windows_NT' then -- why can't you just be normal?!
      local tempfile = install_path .. tostring(vim.uv.hrtime())
      util.rename(install_path, tempfile) -- parser may be in use: rename...
      util.remove(tempfile) -- ...and mark for garbage collection
    end

    local parser_lib_name = fs.joinpath(compile_dir, 'parser.so')
    local err = util.copyfile(parser_lib_name, install_path)
    async.main()
    if err then
      return logger:error('Error during parser installation: %s', err)
    end
  end

  if not info.path then
    local revision = parsers.target_revision(lang)
    if revision then
      util.write_file(parsers.revision_file(lang), revision)
    end
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
    logger:info(('Installing queries %s...'):format(lang))
    util.remove(queries)
    local err = util.mkpath(queries)
    for f in fs.dir(queries_src) do
      local src = fs.joinpath(queries_src, f)
      local dest = fs.joinpath(queries, f)
      util.link(src, dest)
    end
    async.main()

    if err then
      return logger:error(err)
    end
  end

  if install_info and not install_info.path then
    util.remove(parsers.src_dir(lang))
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
--- @param generate? boolean
--- @return ts_install.install.Status status
local function try_install_lang(lang, generate)
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
--- @field generate? boolean
--- @field skip? table
--- @field package _auto? true

--- @async
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
      local status = try_install_lang(lang, options.generate)
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

  if options and options._auto then
    languages = parsers.norm_languages(languages, { installed = true, ignored = true })
    if #languages == 0 then
      return true
    end
  else
    languages = parsers.norm_languages(languages, options and options.skip)
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
    install(languages)
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
    if not util.stat(d) then
      logger:debug('Removing %s', d)
      util.remove(d)
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
