local fs = vim.fs

local async = require('ts-install.async')
local log = require('ts-install.log')
local util = require('ts-install.util')
local parsers = require('ts-install.parsers')

local M = {}

--- @param path string
--- @return string
local function temp_path(path)
  return fs.joinpath(fs.dirname(path), ('.%s.tmp'):format(fs.basename(path)))
end

--- @async
--- @param lang string
--- @return boolean
local function parser_needs_update(lang)
  local info = parsers.install_info(lang)
  if info and (info.url or info.path) then
    local ok, revision_file = pcall(util.read_file, parsers.revision_file(lang))
    -- Always update if:
    -- - error reading revision file (missing)
    -- - lang has no target revision (missing url)
    -- - revision file does not match target revision
    return not ok or revision_file ~= parsers.target_revision(lang)
  end

  return false
end

--- @async
--- @param lang string
--- @return boolean
local function queries_need_update(lang)
  local queries = parsers.queries_dir(lang)
  local queries_src = parsers.queries_src_dir(lang)

  -- Queries bundled with a downloaded parser are unavailable after its source
  -- tree is cleaned up. A parser revision change will reinstall those queries.
  if util.stat(queries_src) then
    return false
  elseif util.stat(queries) then
    return true
  end

  -- Git replaces changed query files, leaving installed hard links on the old inode.
  local installed = {} --- @type table<string, true>
  for f in fs.dir(queries) do
    installed[f] = true
  end

  for f in fs.dir(queries_src) do
    local src = fs.joinpath(queries_src, f)
    local dest = fs.joinpath(queries, f)
    local src_err, src_stat = util.stat(src)
    local dest_err, dest_stat = util.stat(dest)
    if src_err or dest_err or not src_stat or not dest_stat then
      return true
    end
    if src_stat.dev ~= dest_stat.dev or src_stat.ino ~= dest_stat.ino then
      return true
    end
    installed[f] = nil
  end

  return next(installed) ~= nil
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
    async.await(vim.schedule)
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
    async.await(vim.schedule)
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
  if vim.fn.executable('tree-sitter') == 0 then
    return log.error('tree-sitter cli is not available')
  end

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
      { 'tree-sitter', 'generate', '--abi', ts_ver, grammar_json },
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
    local parser_lib_name = fs.joinpath(compile_dir, 'parser.so')
    local staged = temp_path(install_path)
    util.remove(staged)
    local err = util.copyfile(parser_lib_name, staged)
    async.await(vim.schedule)
    if err then
      util.remove(staged)
      return logger:error('Error during parser installation: %s', err)
    end

    local backup_path
    if vim.uv.os_uname().sysname == 'Windows_NT' then
      local install_dir = fs.dirname(fs.dirname(install_path))
      backup_path = fs.joinpath(install_dir, ('.ts-install.%s.parser.old'):format(lang))
    end
    local backup
    err = util.rename(staged, install_path)
    if err and backup_path and not util.stat(install_path) then
      -- Windows may not replace a parser that is in use. Move the old parser
      -- aside, but keep it until the new parser is installed.
      util.remove(backup_path)
      err = util.rename(install_path, backup_path)
      if not err then
        backup = backup_path
        err = util.rename(staged, install_path)
      end
    end

    async.await(vim.schedule)
    if err then
      util.remove(staged)
      if backup then
        local restore_err = util.rename(backup, install_path)
        if restore_err then
          return logger:error('%s (could not restore previous parser: %s)', err, restore_err)
        end
      end
      return logger:error('Error during parser installation: %s', err)
    end
    if backup_path then
      util.remove(backup_path)
    end
  end
end

--- Install a complete set of query links.
---
--- Links are first created in a temporary directory. Existing queries are kept
--- as a backup until the new directory is in place, and setup() restores that
--- backup after a forced exit. Both directories stay outside queries/ because
--- every entry inside queries/ is treated as an installed language.
--- @async
--- @param lang string
--- @param logger ts_install.Logger
--- @return string? err
local function install_queries(lang, logger)
  local queries_src = parsers.queries_src_dir(lang)
  local queries = parsers.queries_dir(lang)
  local install_dir = fs.dirname(fs.dirname(queries))
  local staged = fs.joinpath(install_dir, ('.ts-install.%s.queries.tmp'):format(lang))
  local backup = fs.joinpath(install_dir, ('.ts-install.%s.queries.old'):format(lang))
  logger:info(('Installing queries %s...'):format(lang))
  util.remove(staged)
  local err = util.mkpath(staged)
  if err then
    return logger:error('%s', err)
  end

  for f in fs.dir(queries_src) do
    local src = fs.joinpath(queries_src, f)
    local dest = fs.joinpath(staged, f)
    err = util.link(src, dest)
    if err then
      util.remove(staged)
      return logger:error('%s', err)
    end
  end

  local had_queries = not util.stat(queries)
  if had_queries then
    util.remove(backup)
    err = util.rename(queries, backup)
    if err then
      util.remove(staged)
      return logger:error('%s', err)
    end
  end

  err = util.rename(staged, queries)
  if err then
    util.remove(staged)
    if had_queries then
      local restore_err = util.rename(backup, queries)
      if restore_err then
        return logger:error('%s (could not restore previous queries: %s)', err, restore_err)
      end
    end
    return logger:error('%s', err)
  end
  util.remove(backup)
  async.await(vim.schedule)
end

--- @async
--- @param lang string
--- @param generate? boolean
--- @param queries_only? boolean
--- @return string? err
local function install_lang(lang, generate, queries_only)
  local logger = log.new('install/' .. lang)

  local install_info = parsers.install_info(lang)
  if not queries_only and install_info and (install_info.url or install_info.path) then
    local err = install_parser(lang, install_info, logger, generate)
    if err then
      return err
    end
  end

  local err = install_queries(lang, logger)
  if err then
    return err
  end

  if not queries_only and install_info and not install_info.path then
    local revision = parsers.target_revision(lang)
    if revision then
      -- Record the revision only after the parser and queries are installed,
      -- so an interrupted install is retried.
      util.write_file(parsers.revision_file(lang), revision)
    end
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
local install_tasks = {} --- @type table<ts-install.async.Task<any>, true>

local INSTALL_TIMEOUT = 60000

--- @return boolean
function M.has_pending()
  return next(install_tasks) ~= nil
end

--- @async
--- @param lang string
--- @param generate? boolean
--- @param queries_only? boolean
--- @return ts_install.install.Status status
local function try_install_lang(lang, generate, queries_only)
  if install_status[lang] then
    if install_status[lang] == 'installing' then
      vim.wait(INSTALL_TIMEOUT, function()
        return install_status[lang] ~= 'installing'
      end)
      install_status[lang] = 'timeout'
    end
  else
    install_status[lang] = 'installing'
    local err = install_lang(lang, generate, queries_only)
    install_status[lang] = err and 'failed' or 'installed'
  end

  local status = install_status[lang]
  assert(status and status ~= 'installing')
  return status --[[@as ts_install.install.Status]]
end

--- @class ts_install.install.InstallOpts
--- @field generate? boolean
--- @field skip? table
--- @field package _auto? true

--- @async
--- Install a parser
--- @param languages string[]
--- @param options? ts_install.install.InstallOpts
--- @param queries_only? table<string, true>
--- @return boolean true if at least one language was installed, false otherwise
local function install(languages, options, queries_only)
  options = options or {}

  local tasks = {} --- @type ts-install.async.Task<any>[]
  local done = 0
  for _, lang in ipairs(languages) do
    local task = async
      .run(function()
        async.await(vim.schedule)
        local status = try_install_lang(lang, options.generate, queries_only and queries_only[lang])
        if status == 'installed' then
          done = done + 1
        end
      end)
      :raise_on_error()

    install_tasks[task] = true
    task:wait(function()
      install_tasks[task] = nil
    end)
    tasks[#tasks + 1] = task
  end

  async.await_all(tasks)
  if #tasks > 1 then
    async.await(vim.schedule)
    log.info('Installed %d/%d languages', done, #tasks)
  end

  return done > 0
end

--- @async
--- @param languages string[]|string
--- @param options? ts_install.install.InstallOpts
--- @return boolean true if at least one language was installed, false otherwise
function M.install(languages, options)
  parsers.reload()
  if not languages or #languages == 0 then
    languages = 'all'
  end

  if options and options._auto then
    languages = parsers.norm_languages(languages, { installed = true, ignored = true })
    if #languages == 0 then
      return false
    end
  else
    languages = parsers.norm_languages(languages, options and options.skip)
  end

  return install(languages, options)
end

--- @class ts_install.install.UpdateOpts

--- @async
--- @param languages? string[]|string
--- @param _options? ts_install.install.UpdateOpts
function M.update(languages, _options)
  parsers.reload()
  if not languages or #languages == 0 then
    languages = 'all'
  end
  languages = parsers.norm_languages(languages, { ignored = true, missing = true })
  local queries_only = {} --- @type table<string, true>
  local outdated = {} --- @type string[]
  for _, lang in ipairs(languages) do
    if parser_needs_update(lang) then
      outdated[#outdated + 1] = lang
    elseif queries_need_update(lang) then
      queries_only[lang] = true
      outdated[#outdated + 1] = lang
    end
  end
  languages = outdated

  if #languages > 0 then
    install(languages, nil, queries_only)
  else
    log.info('All parsers are up-to-date')
  end
end

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

--- @async
--- @param languages string[]|string
--- @param _options? ts_install.install.UpdateOpts
function M.uninstall(languages, _options)
  languages = parsers.norm_languages(languages or 'all', { missing = true, dependencies = true })

  local installed = parsers.installed()

  local tasks = {} --- @type ts-install.async.Task<any>[]
  local done = 0
  for _, lang in ipairs(languages) do
    local logger = log.new('uninstall/' .. lang)
    if not vim.list_contains(installed, lang) then
      log.warn('Parser for ' .. lang .. ' is is not managed by ts')
    else
      tasks[#tasks + 1] = async
        .run(function()
          local err = uninstall_lang(logger, lang)
          if not err then
            done = done + 1
          end
        end)
        :raise_on_error()
    end
  end

  async.await_all(tasks)
  if #tasks > 1 then
    async.await(vim.schedule)
    log.info('Uninstalled %d/%d languages', done, #tasks)
  end
end

return M
