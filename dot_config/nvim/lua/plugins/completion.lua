vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1"), confirm = false },
})

require("blink.cmp").setup({
  keymap = { preset = "super-tab" },
  appearance = {
    nerd_font_variant = "mono",
    use_nvim_cmp_as_default = true,
  },
  completion = {
    documentation = { auto_show = false },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
    --prebuilt_binaries = { force_version = "v1.10.2" },
  },
})
