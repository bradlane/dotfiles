return {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = {
		".python-version",
		"Pipfile",
		"pyproject.toml",
		"pyrightconfig.json",
		"requirements.txt",
		"setup.cfg",
		"setup.py",
		"uv.lock",
	},
	settings = {
		init_options = {
			settings = {
				logLevel = "debug",
				lineLength = 120,
				organizeImports = true,
				showSyntaxErrors = true,
				fixAll = true,
				codeAction = {
					lint = {
						enable = true,
						preview = true,
					},
				},
			},
		},
	},
}
