vim.g.mapleader = " "

-- Import helper functions used in other config files
require("functions")

-- Import options.lua
require("options")

-- Import keymaps from keymaps.lua
require("keymaps")

-- mini.nvim
require("plugins.mini")

-- snacks
require("plugins.snacks")

-- UI
require("plugins.colors")
require("plugins.which-key")
require("plugins.lualine")

-- Tree-sitter
require("plugins.tree-sitter")

-- LSP
require("plugins.lsp")

-- Code Formatting
require("plugins.formatting")

-- Code Completion
require("plugins.completion")
