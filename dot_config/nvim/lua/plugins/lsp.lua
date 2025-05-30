return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "mason-org/mason.nvim" },
    },
    lazy = false,
    config = function()
      -- Add the same capabilities to ALL server configurations.
      -- Refer to :h vim.lsp.config() for more information.
      -- vim.lsp.config("*", {
      --   capabilities = vim.lsp.protocol.make_client_capabilities()
      -- })

      -- require('mason').setup()
      require("mason-lspconfig").setup({
        automatic_enable = true,
        ensure_installed = {
          "ansiblels",
          "bashls",
          "dockerls",
          "lua_ls",
          "marksman",
          "powershell_es",
          "pyright",
          "ruff",
          "yamlls",
        },
      })
    end,
    keys = {
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
    },
  },
}
