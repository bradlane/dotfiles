-- Buffer switching with Tab in Normal mode
Map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
Map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })

-- vim.keymap.set("x", "<leader>p", [["_dP]])
-- vim.keymap.set({ "n", "x" }, "<leader>p", [["0p]], { desc = "paste from yank register" })
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Window resize with CTRL+Arrows
Map("n", "<C-Up>", ":resize -2<CR>")
Map("n", "<C-Down>", ":resize +2<CR>")
Map("n", "<C-Left>", ":vertical resize -2<CR>")
Map("n", "<C-Right>", ":vertical resize +2<CR>")
