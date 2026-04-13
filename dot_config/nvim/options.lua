-- Options

-- Leader key
vim.g.maplocalleader = " "

-- Time in milliseconds to wait for a mapped sequence to complete
vim.opt.timeoutlen = 500

-- Enable line numbers with relative
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable break indent
vim.o.breakindent = true
-- Don't wrap lines
-- vim.opt.wrap = false

-- Highlight line cursor is on
vim.opt.cursorline = true

-- Tabs & Indents
-- Number of spaces that a <Tab> character represents
vim.opt.tabstop = 2
-- Number of spaces to use for each step of automatic indentation
vim.opt.shiftwidth = 2
-- Number of spaces that a <Tab> counts for during editing operations
vim.opt.softtabstop = 2
-- Converts tabs into spaces when typing
vim.opt.expandtab = true
-- Automatically inserts an extra level of indentation in some cases
vim.opt.smartindent = true
-- Makes <Tab> insert 'shiftwidth' number of spaces at the start of a line
vim.opt.smarttab = true

-- Ignores case when searching patterns
vim.opt.ignorecase = true
-- Automatically switches to case-sensitive search if a capital letter is used
vim.opt.smartcase = true

-- Enables 24-bit RGB colors in the terminal
vim.opt.termguicolors = true

vim.opt.colorcolumn = "120"

-- Hide mode, since using a statusline plugin
vim.opt.showmode = false

-- Sets the height of the command line area at the bottom
vim.opt.cmdheight = 0

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Save undo history, backup and swapfile options
vim.opt.undofile = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undolevels = 10000
