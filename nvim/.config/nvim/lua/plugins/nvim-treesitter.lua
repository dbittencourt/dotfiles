return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
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
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				swap = {
					enable = true,
					swap_next = {
						-- swap parameters/argument with next
						["<leader>na"] = "@parameter.inner",
						-- swap object property with next
						["<leader>np"] = "@property.outer",
						-- swap function with next
						["<leader>nm"] = "@function.outer",
					},
					swap_previous = {
						-- swap parameters/argument with prev
						["<leader>pa"] = "@parameter.inner",
						-- swap object property with prev
						["<leader>pp"] = "@property.outer",
						-- swap function with previous
						["<leader>pm"] = "@function.outer",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = {
							query = "@function.outer",
							desc = "Next method/function def start",
						},
						["]i"] = {
							query = "@conditional.outer",
							desc = "Next conditional start",
						},
						["]z"] = {
							query = "@fold",
							query_group = "folds",
							desc = "Next fold",
						},
					},
					goto_next_end = {
						["]M"] = {
							query = "@function.outer",
							desc = "Next method/function def end",
						},
						["]I"] = {
							query = "@conditional.outer",
							desc = "Next conditional end",
						},
					},
					goto_previous_start = {
						["[m"] = {
							query = "@function.outer",
							desc = "Prev method/function def start",
						},
						["[i"] = {
							query = "@conditional.outer",
							desc = "Prev conditional start",
						},
					},
					goto_previous_end = {
						["[M"] = {
							query = "@function.outer",
							desc = "Prev method/function def end",
						},
						["[I"] = {
							query = "@conditional.outer",
							desc = "Prev conditional end",
						},
					},
				},
			},
		})

		require("treesitter-context").setup({
			max_lines = 3,
			multiline_threshold = 1,
			min_window_height = 20,
		})
	end,
}
