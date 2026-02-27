vim.pack.add({ { src = "https://github.com/rebelot/kanagawa.nvim" } })

local kanagawa = require("kanagawa")
kanagawa.setup({
	colors = {
		theme = {
			all = {
				ui = {
					-- remove color differentiation from line column
					bg_gutter = "none",
				},
			},
		},
	},
	overrides = function(colors)
		local theme = colors.theme
		return {
			-- add `blend = vim.o.pumblend` to enable transparency
			Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
			PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
			PmenuSbar = { bg = theme.ui.bg_m1 },
			PmenuThumb = { bg = theme.ui.bg_p2 },
		}
	end,
})
kanagawa.load("dragon")
