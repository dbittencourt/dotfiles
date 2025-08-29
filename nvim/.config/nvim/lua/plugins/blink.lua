return {
	"saghen/blink.cmp",
	version = "*",
	event = "InsertEnter",
	opts = {
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
	},
	config = function(_, opts)
		local blink = require("blink.cmp")
		blink.setup(opts)

		-- extend neovim completion capabilities
		vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities(nil, true) })
	end,
}
