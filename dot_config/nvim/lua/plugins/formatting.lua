vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    ps1 = { "psscriptanalyzer" },
    python = { "ruff_format", "ruff_organize_imports" },
  },
})

-----  KEYMAPS  -----
local format_it = function() require("conform").format({ async = true, lsp_format = "fallback" }) end
Map("n", "<leader>cf", format_it, { desc = "format document" })

----- FORMATTERS ------

-- PowerShell PSScriptAnalyzer
require("conform").formatters.psscriptanalyzer = {
  command = "pwsh",
  args = {
    "-NoProfile",
    "-Command",
    [[
      $settings = @{
        IncludeRules = @(
          "PSUseConsistentIndentation",
          "PSPlaceOpenBrace",
          "PSAlignAssignmentStatement",
          "PSUseConsistentWhitespace"
        )
        Rules = @{
          PSUseConsistentIndentation = @{
            Enable = $true
            IndentationSize = 4
          }
          PSPlaceOpenBrace = @{
            Enable = $true
            OnSameLine = $true
          }
          PSAlignAssignmentStatement = @{
            Enable = $true
          }
          PSUseConsistentWhitespace = @{
            Enable = $true
            MaxLineLength = 100
          }
        }
      }
      Invoke-Formatter -ScriptDefinition ([Console]::In.ReadToEnd()) -Settings $settings
    ]],
  },
  stdin = true,
}
