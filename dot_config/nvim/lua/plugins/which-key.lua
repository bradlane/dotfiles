return {
  "https://github.com/folke/which-key.nvim",
  lazy = false,
  opts = {
    preset = "helix",
    delay = 0,
    spec = {
      {
        "<leader>b",
        group = "Buffers",
        expand = function() return require("which-key.extras").expand.buf() end,
      },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Debug" },
      -- { "<leader>e", group = "Explore" },
      { "<leader>f", group = "Find" },
      { "g", group = "GoTo" },
    },
  },
}
