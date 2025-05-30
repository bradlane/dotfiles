-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping or just use <C-\><C-n> to exit terminal mode

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Buffers
vim.keymap.set("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })

-- Windows
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move to left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move to right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move to upper window" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes

-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- formatting
vim.keymap.set({ "n" }, "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

-- save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr><esc>", { desc = "write file" })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
