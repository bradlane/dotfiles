vim.pack.add({
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "basedpyright",
    "bashls",
    "dockerls",
    "jsonls",
    "lua_ls",
    "marksman",
    "powershell_es",
    "ruff",
    "sqls",
    "stylua",
    "yamlls",
  },
})

-----  KEYMAPS -----
Map("n", "K", function() vim.lsp.buf.hover() end, { desc = "LSP Hover" })
Map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
Map("n", "<leader>cr", function() vim.lsp.buf.rename() end, { desc = "Rename" })
-- Map("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "prev diag" })
-- Map("n", "<leader>dn", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "next diag" })
-- Map("n", "<leader>dl", function() vim.diagnostic.setloclist() end, { desc = "list diagnostic" })
-- Map("n", "<leader>df", function() vim.diagnostic.open_float() end, { desc = "floating diagnostic" })
