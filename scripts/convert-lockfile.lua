#!/usr/bin/env -S nvim -l

vim.opt.runtimepath:append('.')

local util = require('ts.util')
local parsers = require('ts.parser_info')

local filename = require('ts.install').get_package_path('lockfile.json')
local lockfile = vim.json.decode(util.read_file(filename)) --[[@as table<string,{revision:string}>]]

for k, p in pairs(parsers) do
  if p.install_info then
    p.install_info.revision = lockfile[k].revision
  end
end

-- write new parser file
local header = '--- @type table<string,ts.ParserInfo>\nreturn '
local parser_file = header .. vim.inspect(parsers)
if vim.fn.executable('stylua') == 1 then
  parser_file = vim.system({ 'stylua', '-' }, { stdin = parser_file }):wait().stdout --[[@as string]]
end
util.write_file('lua/ts/parser_info.lua', parser_file)
