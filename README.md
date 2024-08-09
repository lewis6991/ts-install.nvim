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

    -- OPTIONAL
    config = function()
      require('ts').setup({
        ensure_install = {
          'lua',
          'c',
          'bash',
          -- etc
        },
      })
    end
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

    -- OPTIONAL
    config = function()
      require('ts').setup({
        ensure_install = {
          'lua',
          'c',
          'bash',
          -- etc
        },
      })
    end
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

Check [`:h ts-commands`](doc/ts.txt) for a list of all available commands.
