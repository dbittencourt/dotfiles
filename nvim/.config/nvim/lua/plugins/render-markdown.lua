return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.nvim",
	},
	ft = { "markdown" },
	config = function()
		local header_colors = {
			{ "#cc6000", "#2D282C" },
			{ "#f9d791", "#2D282C" },
			{ "#b7d0ae", "#252C2C" },
			{ "#4e8ca2", "#182931" },
			{ "#4d699b", "#262336" },
			{ "#624c83", "#29273A" },
		}
		for i = 1, 6 do
			local fg, bg = header_colors[math.min(i, #header_colors)][1], header_colors[math.min(i, #header_colors)][2]
			vim.api.nvim_set_hl(0, "@markup.heading." .. i .. ".markdown", { fg = fg, bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, { fg = fg, bold = true })
			vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", { bg = bg })
		end
		vim.api.nvim_set_hl(0, "@markup.quote", { fg = "#F2CDCD" })
		vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = "#F2CDCD" })

		require("render-markdown").setup({
			render_modes = { "n", "c", "t" },
			completions = { blink = { enabled = true } },
		})
	end,
}
