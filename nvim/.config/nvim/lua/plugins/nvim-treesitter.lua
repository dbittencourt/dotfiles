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

local textobjects = require("nvim-treesitter-textobjects")
textobjects.setup({
	move = {
		-- whether to set jumps in the jumplist
		set_jumps = true,
	},
})

local select = require("nvim-treesitter-textobjects.select")
local swap = require("nvim-treesitter-textobjects.swap")
local move = require("nvim-treesitter-textobjects.move")

-- enable syntax highlighting, folding, indentation and keymaps
vim.api.nvim_create_autocmd("FileType", {
	pattern = languages,
	callback = function(ev)
		vim.treesitter.start()
		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt_local.foldmethod = "expr"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

		vim.keymap.set({ "x", "o" }, "ac", function()
			select.select_textobject("@class.outer", "textobjects")
		end, { buffer = ev.buf })
		vim.keymap.set({ "x", "o" }, "ic", function()
			select.select_textobject("@class.inner", "textobjects")
		end, { buffer = ev.buf })
		vim.keymap.set({ "x", "o" }, "am", function()
			select.select_textobject("@function.outer", "textobjects")
		end, { buffer = ev.buf })
		vim.keymap.set({ "x", "o" }, "im", function()
			select.select_textobject("@function.inner", "textobjects")
		end, { buffer = ev.buf })
		vim.keymap.set({ "x", "o" }, "ao", function()
			select.select_textobject("@block.outer", "textobjects")
		end, { buffer = ev.buf })
		vim.keymap.set({ "x", "o" }, "io", function()
			select.select_textobject("@block.inner", "textobjects")
		end, { buffer = ev.buf })

		vim.keymap.set("n", "<leader>na", function()
			swap.swap_next("@parameter.inner")
		end, { buffer = ev.buf, desc = "Swap parameters/argument with next" })
		vim.keymap.set("n", "<leader>pa", function()
			swap.swap_next("@parameter.inner")
		end, { buffer = ev.buf, desc = "Swap parameters/argument with prev" })
		vim.keymap.set("n", "<leader>np", function()
			swap.swap_next("@property.outer")
		end, { buffer = ev.buf, desc = "Swap object property with next" })
		vim.keymap.set("n", "<leader>pp", function()
			swap.swap_next("@property.outer")
		end, { buffer = ev.buf, desc = "Swap object property with prev" })
		vim.keymap.set("n", "<leader>nm", function()
			swap.swap_next("@function.outer")
		end, { buffer = ev.buf, desc = "Swap function with next" })
		vim.keymap.set("n", "<leader>pm", function()
			swap.swap_next("@function.outer")
		end, { buffer = ev.buf, desc = "Swap function with previous" })

		vim.keymap.set({ "n", "x", "o" }, "]m", function()
			move.goto_next_start("@function.outer", "textobjects")
		end, { buffer = ev.buf, desc = "Next method/function def start" })
		vim.keymap.set({ "n", "x", "o" }, "]M", function()
			move.goto_next_end("@function.outer", "textobjects")
		end, { buffer = ev.buf, desc = "Next method/function def end" })
		vim.keymap.set({ "n", "x", "o" }, "[m", function()
			move.goto_previous_start("@function.outer", "textobjects")
		end, { buffer = ev.buf, desc = "Prev method/function def start" })
		vim.keymap.set({ "n", "x", "o" }, "[M", function()
			move.goto_previous_end("@function.outer", "textobjects")
		end, { buffer = ev.buf, desc = "Prev method/function def end" })
		vim.keymap.set({ "n", "x", "o" }, "]i", function()
			move.goto_next_start("@conditional.outer", "textobjects")
		end, { buffer = ev.buf, desc = "Next conditional start" })
		vim.keymap.set({ "n", "x", "o" }, "]I", function()
			move.goto_next_end("@conditional.outer", "textobjects")
		end, { buffer = ev.buf, desc = "Next conditional end" })
		vim.keymap.set({ "n", "x", "o" }, "[i", function()
			move.goto_previous_start("@conditional.outer", "textobjects")
		end, { buffer = ev.buf, desc = "Prev conditional start" })
		vim.keymap.set({ "n", "x", "o" }, "[I", function()
			move.goto_previous_end("@conditional.outer", "textobjects")
		end, { buffer = ev.buf, desc = "Prev conditional end" })
	end,
})
