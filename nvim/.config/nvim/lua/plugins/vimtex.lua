return {
	"lervag/vimtex",
	ft = { "tex" },
	init = function()
		vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" }
	end,
}
