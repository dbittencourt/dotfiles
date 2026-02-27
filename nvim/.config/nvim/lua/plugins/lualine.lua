vim.pack.add({ { src = "https://github.com/nvim-lualine/lualine.nvim" } })

-- mock nvim-web-devicons to use mini.icons instead
require("mini.icons").mock_nvim_web_devicons()
require("lualine").setup({
	options = {
		theme = "auto",
		section_separators = "",
		component_separators = "",
	},
	sections = {
		lualine_c = {
			{
				"filename",
				path = 1, -- show current file path
			},
		},
		lualine_x = {
			{
				"diagnostics",
				sources = { "nvim_lsp" },
				sections = { "error", "warn", "info", "hint" },
				symbols = {
					error = " ",
					warn = " ",
					info = " ",
					hint = " ",
				},
				colored = true,
				update_in_insert = false,
				always_visible = false,
			},
			{ "encoding" },
			{ "fileformat" },
			{ "filetype" },
		},
	},
	tabline = {
		lualine_a = {
			{
				"tabs",
				max_length = vim.api.nvim_win_get_width(0), --vim.o.columns / 3
				mode = 1, -- shows tab name
				path = 0, -- shows just the filename
				show_modified_status = true,
			},
		},
	},
})
