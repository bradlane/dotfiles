vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
})

-- Better Around/Inside textobjects
require("mini.ai").setup({ n_lines = 500 })

-- Auto Bracket Pairs
require("mini.pairs").setup()

-- Interactive selection mover
require("mini.move").setup()

-- Basic Git & diff
require("mini.git").setup()
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = " ", change = " ", delete = "" },
  },
})

-- File manager
require("mini.files").setup({
  -- use_as_default_explorer = true,
  mappings = {
    go_in_plus = "<CR>",
  },
})

-----  KEYMAPS  -----
Map("n", "-", function() MiniFiles.open() end, { desc = "Files" })
