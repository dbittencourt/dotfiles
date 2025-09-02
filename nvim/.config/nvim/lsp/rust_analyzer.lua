-- install with: rustup component add rust-analyzer

return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json" },
	settings = {
		["rust-analyzer"] = {
			inlayHints = {
				chainingHints = { enable = false },
			},
		},
	},
}
