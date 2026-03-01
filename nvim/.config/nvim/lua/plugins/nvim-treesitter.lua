vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		data = {
			run = function(_)
				vim.cmd("TSUpdate")
			end,
		},
	},
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
})

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

-- enable syntax highlighting, folding, indentation and keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = languages,
	callback = function()
		vim.treesitter.start()
		vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.o.foldmethod = "expr"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		local textobjects = require("nvim-treesitter-textobjects")

		textobjects.setup({
			move = {
				-- whether to set jumps in the jumplist
				set_jumps = true,
			},
		})

		vim.keymap.set("n", "<leader>na", function()
			textobjects.swap.swap_next("@parameter.inner")
		end, { desc = "Swap parameters/argument with next" })

		vim.keymap.set("n", "<leader>pa", function()
			textobjects.swap.swap_next("@parameter.inner")
		end, { desc = "Swap parameters/argument with prev" })

		vim.keymap.set("n", "<leader>np", function()
			textobjects.swap.swap_next("@property.outer")
		end, { desc = "Swap object property with next" })

		vim.keymap.set("n", "<leader>pp", function()
			textobjects.swap.swap_next("@property.outer")
		end, { desc = "Swap object property with prev" })

		vim.keymap.set("n", "<leader>nm", function()
			textobjects.swap.swap_next("@function.outer")
		end, { desc = "Swap function with next" })

		vim.keymap.set("n", "<leader>pm", function()
			textobjects.swap.swap_next("@function.outer")
		end, { desc = "Swap function with previous" })

		vim.keymap.set({ "n", "x", "o" }, "]m", function()
			textobjects.move.goto_next_start("@function.outer", "textobjects")
		end, { desc = "Next method/function def start" })

		vim.keymap.set({ "n", "x", "o" }, "]M", function()
			textobjects.move.goto_next_end("@function.outer", "textobjects")
		end, { desc = "Next method/function def end" })

		vim.keymap.set({ "n", "x", "o" }, "[m", function()
			textobjects.move.goto_previous_start("@function.outer", "textobjects")
		end, { desc = "Prev method/function def start" })

		vim.keymap.set({ "n", "x", "o" }, "[M", function()
			textobjects.move.goto_previous_end("@function.outer", "textobjects")
		end, { desc = "Prev method/function def end" })

		vim.keymap.set({ "n", "x", "o" }, "]i", function()
			textobjects.move.goto_next_start("@conditional.outer", "textobjects")
		end, { desc = "Next conditional start" })

		vim.keymap.set({ "n", "x", "o" }, "]I", function()
			textobjects.move.goto_next_end("@conditional.outer", "textobjects")
		end, { desc = "Next conditional end" })

		vim.keymap.set({ "n", "x", "o" }, "[i", function()
			textobjects.move.goto_previous_start("@conditional.outer", "textobjects")
		end, { desc = "Prev conditional start" })

		vim.keymap.set({ "n", "x", "o" }, "[I", function()
			textobjects.move.goto_previous_end("@conditional.outer", "textobjects")
		end, { desc = "Prev conditional end" })
	end,
})
