local jsts_settings = {
	inlayHints = {
		functionLikeReturnTypes = { enabled = true },
		parameterNames = {
			enabled = "literals",
			suppressWhenArgumentMatchesName = true,
		},
		variableTypes = { enabled = true },
	},
}

---@type vim.lsp.Config
return {
	cmd = { "tsgo", "--lsp", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_dir = function(bufnr, on_dir)
		local project_root = vim.fs.root(bufnr, {
			"package-lock.json",
			"yarn.lock",
			"pnpm-lock.yaml",
			"bun.lockb",
			"bun.lock",
		})
		if not project_root then
			return
		end

		local config = vim.fs.find({ "tsconfig.json", "jsconfig.json" }, {
			path = vim.api.nvim_buf_get_name(bufnr),
			type = "file",
			limit = 1,
			upward = true,
			stop = vim.fs.dirname(project_root),
		})[1]
		if config then
			on_dir(project_root)
		end
	end,
	settings = {
		javascript = jsts_settings,
		typescript = jsts_settings,
	},
}
