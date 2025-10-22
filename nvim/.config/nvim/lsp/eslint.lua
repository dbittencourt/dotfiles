-- install with: npm i -g vscode-langservers-extracted

return {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"graphql",
	},
	root_markers = {
		".eslintrc",
		".eslintrc.js",
		".eslintrc.json",
		"eslint.config.js",
		"eslint.config.mjs",
	},
	settings = {
		validate = "on",
		packageManager = nil,
		useESLintClass = false,
		experimental = { useFlatConfig = false },
		codeActionOnSave = { enable = false, mode = "all" },
		format = false,
		quiet = false,
		onIgnoredFiles = "off",
		options = {},
		rulesCustomizations = {},
		run = "onType",
		problems = { shortenToSingleLine = false },
		nodePath = "",
		workingDirectory = { mode = "location" },
		codeAction = {
			disableRuleComment = { enable = true, location = "separateLine" },
			showDocumentation = { enable = true },
		},
	},
	before_init = function(params, config)
		-- set the workspace folder for correct search of tsconfig.json files
		config.settings.workspaceFolder = {
			uri = params.rootPath,
			name = vim.fn.fnamemodify(params.rootPath, ":t"),
		}
	end,
}
