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
        { "<leader>b", group = "[B]uffers" },
        { "<leader>c", group = "[C]ode" },
        { "<leader>f", group = "[F]iles" },
        { "<leader>g", group = "[G]it" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>u", group = "[U]I"}
      },
    },
  },
}
