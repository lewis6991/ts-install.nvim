local fs = vim.fs
local uv = vim.uv

local log = require('ts-install.log')
local async = require('ts-install.async')

--- @type fun(path: string, mode: integer): string?
local mkdir = async.wrap(3, uv.fs_mkdir)

--- @type fun(path: string): string?
local unlink = async.wrap(2, uv.fs_unlink)

--- @type fun(path: string): string?
local rmdir = async.wrap(2, uv.fs_rmdir)

--- @type fun(path: string): string?, uv.fs_stat.result?
local lstat = async.wrap(2, uv.fs_lstat)

local M = {}

--- @type fun(path: string): string?, uv.fs_stat.result?
M.stat = async.wrap(2, uv.fs_stat)

--- @type fun(path: string, new_path: string, flags?: table): string?
M.copyfile = async.wrap(4, uv.fs_copyfile)

--- @type fun(path: string, new_path: string): string?
M.rename = async.wrap(3, uv.fs_rename)

--- @type fun(path: string, new_path: string): string?
M.link = async.wrap(3, uv.fs_link)

--- @type fun(path: string): string?, string?
M.realpath = async.wrap(2, uv.fs_realpath)

--- @async
--- @param cmd string[]
--- @param opts? vim.SystemOpts
--- @return vim.SystemCompleted
function M.system(cmd, opts)
  local cwd = opts and opts.cwd or uv.cwd()
  log.trace('running job: (cwd=%s) %s', cwd, table.concat(cmd, ' '))

  local r = async.await(3, vim.system, cmd, opts) --[[@as vim.SystemCompleted]]
  async.await(vim.schedule)
  if r.stdout and r.stdout ~= '' then
    log.trace('stdout -> %s', r.stdout)
  end
  if r.stderr and r.stderr ~= '' then
    log.trace('stderr -> %s', r.stderr)
  end

  return r
end

--- @async
--- @param path string
--- @param mode? string
--- @return string? err
function M.mkpath(path, mode)
  local parent = fs.dirname(path)
  if not parent:match('^[./]$') and not uv.fs_stat(parent) then
    M.mkpath(parent, mode)
  end

  return mkdir(path, tonumber(mode or '755', 8))
end

--- @param filename string
--- @return string
function M.read_file(filename)
  local file = assert(io.open(filename, 'r'))
  local r = file:read('*a')
  file:close()
  return r
end

--- @param filename string
--- @param content string
function M.write_file(filename, content)
  local file = assert(io.open(filename, 'w'))
  file:write(content)
  file:close()
end

--- @async
--- Recursively delete a directory
--- @param name string
function M.remove(name)
  local err, stat = lstat(name)
  if err or not stat then
    async.await(vim.schedule)
    return
  end

  if stat.type == 'directory' then
    for f in fs.dir(name) do
      M.remove(fs.joinpath(name, f))
    end
    rmdir(name)
    return
  end

  unlink(name)
  async.await(vim.schedule)
end

return M
