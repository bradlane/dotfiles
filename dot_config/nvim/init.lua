vim.g.mapleader = " "

-- Import helper functions used in other config files
require("functions")

-- Import options.lua
require("config.options")

-- Import keymaps from keymaps.lua
require("config.keymaps")

-- Filetype associations
require("config.filetypes")

-- lazy.nvim plugin manager & plugins dir
require("config.lazy")

require("config.ui2")
