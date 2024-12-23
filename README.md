This plugin provides functions for installing, updating, and removing **tree-sitter parsers**.

## Requirements

- [Nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) for queries and parser information.
- Neovim 0.10.0 or later
- `tar` and `curl` in your path (or alternatively `git`)
- [`tree-sitter`](https://github.com/tree-sitter/tree-sitter) CLI (0.22.6 or later)
- a C compiler in your path (see <https://docs.rs/cc/latest/cc/#compile-time-requirements>)

## Installation

[pckr.nvim](https://github.com/lewis6991/pckr.nvim):
```lua
require('pckr').add({
  { 'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    config_pre = function()
      vim.g.loaded_nvim_treesitter = 1
    end
  },

  { 'lewis6991/ts-install.nvim',
    requires = 'nvim-treesitter/nvim-treesitter',
    -- OPTIONAL
    config = function()
      require('ts-install').setup({
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

[lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
require('lazy').setup(
  { 'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    init = function()
      vim.g.loaded_nvim_treesitter = 1
    end,
  },

  { 'lewis6991/ts-install.nvim',
    -- OPTIONAL
    config = function()
      require('ts-install').setup({
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

`ts-install.nvim` can be optionally configured by calling `setup()`.
The following snippet lists the available options and their default values.

```lua
require'ts-install'.setup {
  ensure_install = { },

  -- List of parsers to ignore installing
  ignore_install = { },

  -- Automatically install missing parsers when entering buffer
  auto_install = false,

  -- Directory to install parsers and queries to
  install_dir = vim.fn.stdpath('data') .. '/ts-install'
}
```

Check [`:h ts-install-commands`](doc/ts-install.txt) for a list of all available commands.

## Adding additional parsers

```lua
require('ts-install').setup({
  ...,
  parsers = {
    ['<name>'] = {
      --- Information necessary to build and install the parser (empty for query-only language)
      install_info = {
        --- URL of parser repo (Github/Gitlab)
        --- @type string?
        url = ...,

        --- Revision of parser
        --- @type string?
        revision = ...,

        --- Branch of parser repo to download (if not default branch)
        branch = ..., --- @type string?

        --- Parser repo is a local directory; overrides `url`, `revision`, and `branch`
        --- @type string
        path = ...

        --- Location of `grammar.js` in repo (if not at root, e.g., in a monorepo)
        --- @type string?
        location = ...,

        --- Repo does not contain a `parser.c`; must be generated from grammar first
        --- @type boolean?
        generate = ...,

        --- Parser needs to be generated from `grammar.json`
        --- @type boolean?
        generate_from_json = ...,
      },

      --- List of other languages to install (e.g., if queries inherit from them)
      --- @type string[]
      requires = { ... }
    }
  }
})
```

Example:
```lua
require('ts-install').setup({
  parsers = {
    caddy = {
      install_info = {
        url = 'https://github.com/Samonitari/tree-sitter-caddy',
        branch = 'master',
      }
    }
  },
})
```

## FAQ

### Why does this plugin exist?

The scope of nvim-treesitter is too large and aims to both support the query and parser information for a vast amount of languages,
in addition to the installation and parser management functionality.

The goal of this plugin is to only provide the latter in a more opinionated way.
Specifically a way to install parsers and their queries from variouse sources (currently only nvim-treesitter).

