This plugin provides functions for installing, updating, and removing **tree-sitter parsers**.

# Quickstart

## Requirements

- Nvim-treesitter for queries and parser information.
- Neovim 0.10.0 or later
- `tar` and `curl` in your path (or alternatively `git`)
- [`tree-sitter`](https://github.com/tree-sitter/tree-sitter) CLI (0.22.6 or later)
- a C compiler in your path (see <https://docs.rs/cc/latest/cc/#compile-time-requirements>)

## Installation

pckr.nvim:
```lua
require('pckr').add({
  { 'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    config_pre = function()
      vim.g.loaded_nvim_treesitter = 1
    end
  },

  { 'lewis6991/ts.nvim',
    requires = 'nvim-treesitter/nvim-treesitter',
    run = ':TS update',
  },
})
```

lazy.nvim:
```lua
require('lazy').setup(
  { 'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    init = function()
      vim.g.loaded_nvim_treesitter = 1
    end,
  },

  { 'lewis6991/ts.nvim',
    build = ':TS update',
  }
)
```

## Setup

`ts.nvim` can be optionally configured by calling `setup`.
The following snippet lists the available options and their default values.

```lua
require'ts'.setup {
  -- A list of parser names or tiers ('stable', 'core', 'community', 'unsupported')
  ensure_install = { },

  -- List of parsers to ignore installing
  ignore_install = { 'unsupported' },

  -- Automatically install missing parsers when entering buffer
  auto_install = false,

  -- Directory to install parsers and queries to
  install_dir = vim.fn.stdpath('data') .. '/ts'
}
```

Check [`:h ts-commands`](doc/nvim-treesitter.txt) for a list of all available commands.

# Advanced setup

## Adding parsers

If you have a parser that is not on the list of supported languages (either as a repository on Github or in a local directory), you can add it manually for use by `nvim-treesitter` as follows:

1. Add the following snippet in a `User TSUpdate` autocommand:

```lua
vim.api.nvim_create_autocmd('User', { pattern = 'TSUpdate',
callback = function()
  require('ts.parser_info').zimbu = {
    install_info = {
      url = 'https://github.com/zimbulang/tree-sitter-zimbu',
      revision = <sha>, -- commit hash for revision to check out; HEAD if missing
      -- optional entries:
      branch = 'develop', -- only needed if different from default branch
      location = 'parser', -- only needed if the parser is in subdirectory of a "monorepo"
      generate = true, -- only needed if repo does not contain pre-generated src/parser.c
      generate_from_json = true, -- only needed if parser has npm dependencies
    },
  }
end})
```

Alternatively, if you have a local checkout, you can instead use
```lua
    install_info = {
      path = '~/parsers/tree-sitter-zimbu',
      -- optional entries
      location = 'parser', -- only needed if the parser is in subdirectory of a "monorepo"
      generate = true, -- only needed if repo does not contain pre-generated src/parser.c
      generate_from_json = true, -- only needed if parser has npm dependencies
    },
```
This will always use the state of the directory as-is (i.e., `branch` and `revision` will be ignored).

2. If the parser name differs from the filetype(s) used by Neovim, you need to register the parser via

```lua
vim.treesitter.language.register('zimbu', { 'zu' })
```

If Neovim does not detect your language's filetype by default, you can use [Neovim's `vim.filetype.add()`](<https://neovim.io/doc/user/lua.html#vim.filetype.add()>) to add a custom detection rule.

3. Start `nvim` and `:TSInstall zimbu`.

**Note:** Parsers using external scanner need to be written in C. C++ scanners are no longer supported.

### Modifying parsers

You can use the same approach for overriding parser information. E.g., if you always want to generate the `lua` parser from grammar, add
```lua
vim.api.nvim_create_autocmd('User', { pattern = 'TSUpdate',
callback = function()
  require('ts.parser_info').lua.install_info.generate = true
end})
```
