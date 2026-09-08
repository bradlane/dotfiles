return {
  { "https://github.com/ribru17/bamboo.nvim", opts = {} },
  { "https://github.com/rebelot/kanagawa.nvim" },
  { "https://github.com/sainnhe/gruvbox-material" },
  { "savq/melange-nvim" },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      -- Create an Autocommand Group to prevent duplicate handlers
      local group = vim.api.nvim_create_augroup("EverforestDynamicMode", { clear = true })

      -- Funciton to evaluate background & dynamically set options
      local function apply_everforest_settings()
        if vim.o.background == "dark" then
          vim.g.everforest_background = "hard"
        else
          vim.g.everforest_background = "soft"
        end
        -- Static configurations shared across both light/dark environments
        vim.g.everforest_ui_contrast = "high"
        -- vim.g.everforest_better_performance = 1
        vim.g.everforest_enable_italic = true
        vim.g.everforest_float_style = "blend"
        vim.g.everforest_pmenu_style = "blend"
        vim.g.everforest_diagnostic_text_highlight = 1
        -- Re-trigger the colorscheme to enforce the fresh configuration rules
        vim.cmd([[colorscheme everforest]])
      end

      -- Watch for changes on the 'background' option state
      vim.api.nvim_create_autocmd("OptionSet", {
        pattern = "background",
        group = group,
        callback = apply_everforest_settings,
      })

      apply_everforest_settings()
    end,
  },
}
