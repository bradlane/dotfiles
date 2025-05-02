return {
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require("tokyonight").setup({
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      })

      vim.cmd.colorscheme("tokyonight-moon")
    end,
  },
  {
    "sainnhe/everforest",
    priority = 1000,
    init = function()
      -- vim.o.background = "light"
      vim.g.everforest_background = "soft"
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_disable_italic_comment = 1
      vim.g.everforest_dim_inactive_windows = 1
      vim.g.everforest_ui_contrast = "high"
      --vim.cmd.colorscheme("everforest")
      vim.cmd.hi("Comment gui=none")
    end,
  },
  {
    "forest-nvim/sequoia.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd("colorscheme sequoia") -- or 'sequoia-night' / 'sequoia-rise'
    end,
  },
  { "EdenEast/nightfox.nvim" },
}
