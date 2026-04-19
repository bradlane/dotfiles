vim.pack.add({
  { src = "https://github.com/ribru17/bamboo.nvim" },
  { src = "https://github.com/rebelot/kanagawa.nvim" },
  { src = "https://github.com/sainnhe/everforest" },
})

vim.g.everforest_background = "hard"
vim.g.everforest_enable_italic = 1
vim.g.everforest_disable_italic_comment = 1
vim.cmd("colorscheme everforest")

-- vim.cmd("colorscheme bamboo")
--vim.cmd("colorscheme kanagawa-wave")
