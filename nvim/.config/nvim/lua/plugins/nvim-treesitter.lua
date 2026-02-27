vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		data = {
			run = function(_)
				vim.cmd("TSUpdate")
			end,
		},
	},
})
vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" } })
vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" } })

local languages = {
	"angular",
	"bash",
	"c_sharp",
	"c",
	"cpp",
	"css",
	"diff",
	"dockerfile",
	"fish",
	"gitignore",
	"html",
	"javascript",
	"json",
	"latex",
	"lua",
	"markdown_inline",
	"markdown",
	"python",
	"scss",
	"sql",
	"terraform",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
	"rust",
}
local treesitter = require("nvim-treesitter")
treesitter.install(languages)
treesitter.setup()

require("treesitter-context").setup({
	max_lines = 3,
	multiline_threshold = 1,
	min_window_height = 20,
})

-- enable syntax highlighting, folding and indentation
vim.api.nvim_create_autocmd("FileType", {
	pattern = languages,
	callback = function()
		vim.treesitter.start()
		vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.o.foldmethod = "expr"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
