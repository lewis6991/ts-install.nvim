---@meta
error('Cannot require a meta file')

--- @class InstallInfo
---
--- URL of parser repo (Github/Gitlab)
--- @field url string
---
--- Commit hash of parser to download (compatible with queries)
--- @field revision string
---
--- Branch of parser repo to download (if not default branch)
--- @field branch? string
---
--- Location of `grammar.js` in repo (if not at root, e.g., in a monorepo)
--- @field location? string
---
--- Repo does not contain a `parser.c`; must be generated from grammar first
--- @field generate? boolean
---
--- Parser needs to be generated from `grammar.json` (generating from `grammar.js` requires npm)
--- @field generate_from_json? boolean
---
--- Parser repo is a local directory; overrides `url`, `revision`, and `branch`
--- @field path? string

--- @class ParserInfo
---
--- Information necessary to build and install the parser (empty for query-only language)
---
--- @field install_info? InstallInfo
--- List of other languages to install (e.g., if queries inherit from them)
---
--- @field requires? string[]

--- @alias nvim-ts.parsers table<string,ParserInfo>
