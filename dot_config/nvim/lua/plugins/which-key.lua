vim.pack.add({ "https://github.com/folke/which-key.nvim" })
require("which-key").setup({
  preset = "helix",
  delay = 0,
  spec = {
    {
      "<leader>b",
      group = "buffer",
      expand = function()
        return require("which-key.extras").expand.buf()
      end,
    },
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Debug" },
    { "<leader>f", group = "Find" },
  },
})
