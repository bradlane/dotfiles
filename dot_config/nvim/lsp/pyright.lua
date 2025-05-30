return {
  settings = {
    pyright = {
      -- Ruff will do this instead
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis; will use Ruff instead for linting
        -- ignore = { "*" }
      },
    },
  },
}
