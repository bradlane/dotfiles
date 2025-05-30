return {
  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    lazy = false,
    config = function()
      -- Icons in plugins/menus
      require("mini.icons").setup()

      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()

      -- Auto Bracket Pairs
      require("mini.pairs").setup()

      -- Extend f & t to jump to next
      require("mini.jump").setup()

      -- Interactive selection mover
      require("mini.move").setup()

      -- Statusline
      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = true })
      statusline.section_location = function()
        return "%2l:%-2v"
      end

      -- Operators
      require("mini.operators").setup()

      -- File Manager
      require("mini.files").setup({
        use_as_default_explorer = true,
        mappings = {
          go_in_plus = "<CR>",
        },
      })

      -- Basic Git & diff
      require("mini.git").setup()
      require("mini.diff").setup({
        view = {
          style = "sign",
          signs = { add = " ", change = " ", delete = "" },
        },
      })
    end,
    keys = {
      {
        "-",
        function()
          MiniFiles.open()
        end,
        desc = "MiniFiles",
      },
    },
  },
}
