-- install with:
-- mac: brew install lua-language-server
-- arch: yay -S lua-language-server

return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".git", vim.uv.cwd() },
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize 'vim' global
			diagnostics = {
				globals = { "vim" },
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
