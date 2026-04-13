vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
  indent = { enabled = true },
  input = {
    enabled = true,
  },
  picker = {
    enabled = true,
  },
  statuscolumn = { enabled = true },
})

-----  KEYMAPS  -----

-- Picker
Map("n", "<leader><leader>", function() Snacks.picker.files() end, { desc = "Files" })
Map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "buffer" })
Map("n", "<leader>fe", function() Snacks.picker.explorer() end, { desc = "explorer" })
Map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "files" })
Map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "git files" })
Map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "recent" })
Map("n", "<leader>fw", function() Snacks.picker.grep() end, { desc = "word/grep" })

-- LSP
Map("n", "<leader>cl", function() Snacks.picker.lsp_config() end, { desc = "lsp config" })
Map("n", "<leader>cd", function() Snacks.picker.lsp_definitions() end, { desc = "lsp definitions" })
Map("n", "<leader>ci", function() Snacks.picker.lsp_implementations() end, { desc = "lsp implementations" })
Map("n", "<leader>cR", function() Snacks.picker.lsp_references() end, { desc = "lsp references" })
Map("n", "<leader>cs", function() Snacks.picker.lsp_symbols() end, { desc = "lsp symbols" })
