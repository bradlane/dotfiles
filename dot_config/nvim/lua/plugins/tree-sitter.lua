vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
})

-- Tree-sitter parsers to always install
require("nvim-treesitter").install({
  "bash",
  "diff",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitignore",
  "hcl",
  "ini",
  "jq",
  "json",
  "lua",
  "nginx",
  "markdown",
  "markdown_inline",
  "powershell",
  "python",
  "requirements",
  "regex",
  "sql",
  "ssh_config",
  "toml",
  "xml",
  "yaml",
})

-- equivalent to :TSUpdate
require("nvim-treesitter.install").update("all")

require("nvim-treesitter.config").setup({
  auto_install = true, -- autoinstall languages that are not installed yet
})

require("treesitter-context").setup({
  enable = true,
  mode = "cursor",
})
