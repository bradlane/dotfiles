return {
  --  {
  --    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  --    'folke/tokyonight.nvim',
  --    priority = 1000,
  --    init = function()
  --      -- Load the colorscheme here.
  --      -- Like many other themes, this one has different styles, and you could load
  --      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --      vim.cmd.colorscheme 'tokyonight-night'
  --      -- You can configure highlights by doing something like:
  --      vim.cmd.hi 'Comment gui=none'
  --    end,
  --  },

  {
    'sainnhe/everforest',
    priority = 1000,
    init = function()
      vim.o.background = 'light'
      vim.g.everforest_background = 'soft'
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_disable_italic_comment = 1
      vim.g.everforest_dim_inactive_windows = 1
      vim.g.everforest_ui_contrast = 'high'
      vim.cmd.colorscheme 'everforest'
      --vim.cmd.hi 'Comment gui=none'
    end,
  },
  { 'rose-pine/neovim', name = 'rose-pine' },
}
-- vim: ts=2 sts=2 sw=2 et
