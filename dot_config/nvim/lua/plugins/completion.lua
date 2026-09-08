return {
  {
    "saghen/blink.cmp",
    branch = "v1",
    opts = {
      keymap = { preset = "super-tab" },
      appearance = {
        nerd_font_variant = "mono",
        -- use_nvim_cmp_as_default = true,
      },
      completion = {
        documentation = { auto_show = true },
        menu = {
          -- nvim-cmp style menu
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
              { "source_name" },
            },
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
      signature = { enabled = true },
    },
  },
}
