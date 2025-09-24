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
	root_dir = function(bufnr, cb)
		local fname = vim.uri_to_fname(vim.uri_from_bufnr(bufnr))

		local ts_root = vim.fs.find("tsconfig.json", { upward = true, path = fname })[1]
		local git_root = vim.fs.find(".git", { upward = true, path = fname })[1]

		if git_root then
			cb(vim.fn.fnamemodify(git_root, ":h"))
		elseif ts_root then
			cb(vim.fn.fnamemodify(ts_root, ":h"))
		end
	end,
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
