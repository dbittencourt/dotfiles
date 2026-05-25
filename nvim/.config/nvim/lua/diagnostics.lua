vim.diagnostic.config({
	float = {
		source = "if_many",
		format = function(diagnostic)
			return string.format("line %d: %s", diagnostic.lnum + 1, diagnostic.message)
		end,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	virtual_text = { source = "if_many", current_line = true },
	severity_sort = true,
})
