-- PowerShell Editor Services.
-- mason-lspconfig injects `bundle_path` for the mason-installed package; the
-- fallback below keeps this working if mason-lspconfig isn't doing that.
local mason_bundle = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"

return {
  bundle_path = vim.uv.fs_stat(mason_bundle) and mason_bundle or nil,
  filetypes = { "ps1" },
  root_markers = { "PSScriptAnalyzerSettings.psd1", ".git" },
  settings = {
    powershell = {
      codeFormatting = {
        Preset = "OTBS",
        autoCorrectAliases = true,
        useCorrectCasing = true,
      },
      scriptAnalysis = { enable = true },
    },
  },
}
