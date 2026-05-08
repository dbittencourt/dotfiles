-- install with: npm i -g @vtsls/language-server

local jsts_settings = {
	suggest = { completeFunctionCalls = true },
	inlayHints = {
		functionLikeReturnTypes = { enabled = true },
		parameterNames = { enabled = "literals" },
		variableTypes = { enabled = true },
	},
}

return {
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_markers = { { "tsconfig.json", "jsconfig.json", "package.json" }, ".git" },
	settings = {
		typescript = jsts_settings,
		javascript = jsts_settings,
		vtsls = {
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
	},
}
