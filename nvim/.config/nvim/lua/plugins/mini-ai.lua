vim.pack.add({ { src = "https://github.com/nvim-mini/mini.ai" } })

-- advanced text objects
local ai = require("mini.ai")
ai.setup({
	n_lines = 500,
	custom_textobjects = {
		o = ai.gen_spec.treesitter({ -- code block
			a = { "@block.outer", "@conditional.outer", "@loop.outer" },
			i = { "@block.inner", "@conditional.inner", "@loop.inner" },
		}),
		m = ai.gen_spec.treesitter({ -- method/function definition
			a = "@function.outer",
			i = "@function.inner",
		}),
		c = ai.gen_spec.treesitter({ -- class
			a = "@class.outer",
			i = "@class.inner",
		}),
		d = { "%f[%d]%d+" }, -- digits
	},
})
