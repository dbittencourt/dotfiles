-- install with:
-- mac: brew install marksman
-- arch: yay -S marksman

local bin_name = "marksman"
local cmd = { bin_name, "server" }

return {
	cmd = cmd,
	filetypes = { "markdown", "markdown.mdx" },
	root_markers = { ".marksman.toml", ".git" },
}
