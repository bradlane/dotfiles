return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
      { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
      { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
      { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
      { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help" },
      {
        "<c-k>",
        function() return vim.lsp.buf.signature_help() end,
        mode = "i",
        desc = "Signature Help",
      },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" } },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim" },
      { "neovim/nvim-lspconfig" },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      ensure_installed = {
        "ansiblels",
        "basedpyright",
        "bashls",
        "biome",
        "dockerls",
        "gopls",
        "jsonls",
        "lua_ls",
        "marksman",
        "powershell_es",
        "ruff",
        "shellcheck",
        "shfmt",
        "sqls",
        "stylua",
        "yamlls",
        "yamlfmt",
      },
    },
  },
}
