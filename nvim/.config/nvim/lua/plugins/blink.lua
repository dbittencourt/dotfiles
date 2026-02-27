vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("*") },
})

require("blink.cmp").setup({
	keymap = {
		preset = "enter",
	},
	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "mono",
	},
	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
		},
		per_filetype = {
			markdown = { inherit_defaults = true, "markdown" },
		},
		providers = {
			markdown = {
				name = "RenderMarkdown",
				module = "render-markdown.integ.blink",
				fallbacks = { "lsp" },
			},
		},
	},
	fuzzy = { implementation = "prefer_rust" },
	completion = {
		list = {
			selection = {
				preselect = false,
				auto_insert = true,
			},
		},
		trigger = {
			show_on_trigger_character = true,
			show_on_insert_on_trigger_character = true,
		},
		documentation = { auto_show = true },
	},
	snippets = { preset = "default" },
})
