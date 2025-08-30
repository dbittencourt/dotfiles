-- make sure inlay hints are disabled, I'm definitely not a fan
vim.g.inlay_hints = false

vim.diagnostic.config({
	float = {
		source = "if_many",
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
