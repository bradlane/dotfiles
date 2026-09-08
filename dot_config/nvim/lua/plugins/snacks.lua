return {
  {
    "https://github.com/folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- explorer = {},
      indent = {
        enabled = true,
        animate = { enabled = false },
        chunk = { enabled = true },
        scope = {
          treesitter = { enabled = true },
        },
      },
      input = {
        enabled = true,
      },
      picker = {
        enabled = true,
      },
      -- scope = { enabled = true },
      statuscolumn = { enabled = true },
    },
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader><leader>", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>e", function() Snacks.picker.explorer() end, desc = "File Explorer" },
      { "<leader>.", function() Snacks.scratch() end, desc = "Scratch Buffer" },
      -- Code/LSP
      { "<leader>cD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "LSP Info" },
      { "<leader>cs", function() Snacks.picker.lsp_symbols() end, desc = "lsp symbols" },
      -- Git
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    },
  },
}

-----  KEYMAPS  -----

-- Picker
-- Map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "buffer" })
-- Map("n", "<leader>fe", function() Snacks.picker.explorer() end, { desc = "explorer" })
-- Map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "files" })
-- Map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "git files" })
-- Map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "recent" })
-- Map("n", "<leader>fw", function() Snacks.picker.grep() end, { desc = "word/grep" })
--
-- -- LSP
-- Map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go to definition (LSP)" })
-- Map("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Go to Declaration (LSP)" })
-- Map("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "Go to implementations (LSP)" })
--Map("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References (LSP)" })
