-- install with:
-- macos: brew install harper
-- arch: pacman -S harper

return {
	cmd = { "harper-ls", "--stdio" },
	filetypes = {
		"gitcommit",
		"html",
		"markdown",
	},
	root_markers = { ".git" },
}
