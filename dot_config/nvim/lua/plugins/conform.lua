return {
  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "n",
        desc = "Format",
      },
    },
    opts = {
      -- notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = "fallback",
          }
        end
      end,
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
      formatters_by_ft = {
        lua = { "stylua" },
        ps1 = { "psscriptanalyzer" },
        python = { "ruff_format", "ruff_organize_imports" },
      },
    },
  },
}
