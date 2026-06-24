vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		javascript = { "oxfmt" },
		javascriptreact = { "oxfmt" },
		typescript = { "oxfmt" },
		typescriptreact = { "oxfmt" },
		css = { "oxfmt" },
		scss = { "oxfmt" },
		less = { "oxfmt" },
		html = { "oxfmt" },
		json = { "oxfmt" },
		jsonc = { "oxfmt" },
		yaml = { "oxfmt" },
		markdown = { "oxfmt" },
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_format" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		sh = { "shfmt" },
		fish = { "fish_indent", "fish_lint" },
		cs = { "csharpier" },
		c = { "clang-format" },
		csharp = { "csharpier" },
		cpp = { "clang-format" },
		sql = { "sql_formatter" },
		pgsql = { "sql_formatter" },
		rust = { "rustfmt" },
		swift = { "swift_format" },
	},
	formatters = {
		fish_lint = {
			command = "fish",
			args = { "--no-execute", "$FILENAME" },
			stdin = false,
		},
		sql_formatter = {
			command = "sql-formatter",
			args = { "--language", "tsql" },
			stdin = true,
		},
	},
	format_on_save = { lsp_format = "fallback", timeout_ms = 1000 },
})

vim.keymap.set({ "n", "v" }, "<leader>mp", function()
	conform.format({
		lsp_format = "fallback",
		async = false,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })
