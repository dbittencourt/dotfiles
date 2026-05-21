---@type vim.lsp.Config
return {
	cmd = { "oxlint", "--lsp" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = {
		"oxlint.config.cjs",
		"oxlint.config.cts",
		"oxlint.config.js",
		"oxlint.config.mjs",
		"oxlint.config.mts",
		"oxlint.config.ts",
		".oxlintrc.json",
		".oxlintrc.jsonc",
	},
}
