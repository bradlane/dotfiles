return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    -- pwsh startup + Invoke-Formatter needs far more than the usual 500ms
    format_on_save = function(bufnr)
      local timeout_ms = vim.bo[bufnr].filetype == "ps1" and 5000 or 500
      return { timeout_ms = timeout_ms, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
      go = { "goimports", "gofumpt" },
      json = { "biome" },
      lua = { "stylua" },
      ps1 = { "psscriptanalyzer" },
      python = { "ruff_format", "ruff_organize_imports" },
      -- shellcheck is a linter, not a formatter; bashls surfaces its diagnostics
      sh = { "shfmt" },
      yaml = { "yamlfmt" },
      ["yaml.ansible"] = { "yamlfmt" },
    },
    ----- CUSTOM FORMATTERS ------
    formatters = {
      psscriptanalyzer = {
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
      },
    },
  },
}
