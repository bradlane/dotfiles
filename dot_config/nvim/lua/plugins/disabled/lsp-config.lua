return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    --config = function()
    --  require("mason").setup()
    --end,
    opts = {}
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_nvim_lsp.default_capabilities())

      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        --capabilities = capabilities,
      })
    end,
    keys = {
      { "K", vim.lsp.buf.hover(), desc = "Hover" },
      {
        "<leader>cl",
        function()
          Snacks.picker.lsp_config()
        end,
        desc = "Lsp Info",
      },
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
      { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
      { "<leader>cf", vim.lsp.buf.format, desc = "Format (lsp buf)" },
    },
  },
}
