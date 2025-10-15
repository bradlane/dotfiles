return {
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      preset = "helix",
      delay = 0,
      icons = {
        mappings = true,
      },
      spec = {
        {
          "<leader>b",
          group = "buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find/file" },
        { "<leader>g", group = "git" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "toggle" },
        { "<leader>u", group = "ui" },
        { "<leader>x", group = "diag/quickfix" },
      },
    },
  },
  -- Colorschemes
  -- Change default colorschme by setting 'lazy = false' (should only be set on one)
  -- { "catppuccin/nvim", lazy = true, name = "catppuccin", priority = 1000 },
  -- {
  --   "neanias/everforest-nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("everforest").setup({
  --       background = 'soft',
  --       italics = true,
  --       ui_contrast = 'high',
  --
  --     })
  --     vim.o.background = "light"
  --   end,
  -- },
  {
    "sainnhe/everforest",
    priority = 1000,
    lazy = false,
    config = function()
      -- vim.o.background = "light"
      -- vim.g.everforest_background = "soft"
      vim.g.everforest_background = "medium"
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_disable_italic_comment = 1
      vim.g.everforest_dim_inactive_windows = 1
      --vim.g.everforest_ui_contrast = "high"
      vim.cmd.colorscheme("everforest")
      vim.cmd.hi("Comment gui=none")
    end,
  },
  --{
  --  "EdenEast/nightfox.nvim",
  --  priority = 1000,
  --  lazy = true,
  --  config = function()
  --    vim.cmd.colorscheme("duskfox")
  --  end,
  --},
  --{
  --  "folke/tokyonight.nvim",
  --  priority = 1000,
  --  lazy = true,
  --  config = function()
  --    require("tokyonight").setup()
  --    vim.cmd.colorscheme("tokyonight-moon")
  --  end,
  --},
  --{
  --  "luisiacc/gruvbox-baby",
  --  priority = 1000,
  --  lazy = true,
  --  config = function()
  --    vim.g.gruvbox_baby_background_color = 'dark'
  --    vim.cmd.colorscheme("gruvbox-baby")
  --  end,
  --},
  --{
  --  "marko-cerovac/material.nvim",
  --  priorty = 1000,
  --  lazy = true,
  --  opts = {},
  --},

  -- Other UI stuff
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = { multiline = false },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },
}
