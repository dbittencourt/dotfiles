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
	group = vim.api.nvim_create_augroup("dbitt/treesitter_ft", { clear = true }),
	pattern = languages,
	callback = function(ev)
		vim.treesitter.start()
		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt_local.foldmethod = "expr"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

		local selects = {
			{ "ac", "@class.outer" },
			{ "ic", "@class.inner" },
			{ "am", "@function.outer" },
			{ "im", "@function.inner" },
			{ "ao", "@block.outer" },
			{ "io", "@block.inner" },
		}
		for _, s in ipairs(selects) do
			vim.keymap.set({ "x", "o" }, s[1], function()
				select.select_textobject(s[2], "textobjects")
			end, { buf = ev.buf })
		end

		local swaps = {
			{ "<leader>na", "swap_next", "@parameter.inner", "Swap param with next" },
			{ "<leader>pa", "swap_previous", "@parameter.inner", "Swap param with prev" },
			{ "<leader>np", "swap_next", "@property.outer", "Swap property with next" },
			{ "<leader>pp", "swap_previous", "@property.outer", "Swap property with prev" },
			{ "<leader>nm", "swap_next", "@function.outer", "Swap function with next" },
			{ "<leader>pm", "swap_previous", "@function.outer", "Swap function with prev" },
		}
		for _, s in ipairs(swaps) do
			vim.keymap.set("n", s[1], function()
				swap[s[2]](s[3])
			end, { buf = ev.buf, desc = s[4] })
		end

		local moves = {
			{ "]m", "goto_next_start", "@function.outer", "Next function start" },
			{ "]M", "goto_next_end", "@function.outer", "Next function end" },
			{ "[m", "goto_previous_start", "@function.outer", "Prev function start" },
			{ "[M", "goto_previous_end", "@function.outer", "Prev function end" },
			{ "]i", "goto_next_start", "@conditional.outer", "Next conditional start" },
			{ "]I", "goto_next_end", "@conditional.outer", "Next conditional end" },
			{ "[i", "goto_previous_start", "@conditional.outer", "Prev conditional start" },
			{ "[I", "goto_previous_end", "@conditional.outer", "Prev conditional end" },
		}
		for _, m in ipairs(moves) do
			vim.keymap.set({ "n", "x", "o" }, m[1], function()
				move[m[2]](m[3], "textobjects")
			end, { buf = ev.buf, desc = m[4] })
		end
	end,
})
