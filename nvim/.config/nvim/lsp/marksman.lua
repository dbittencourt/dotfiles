-- markdown config
-- Pre-built binaries can be downloaded from https://github.com/artempyanykh/marksman/releases
local bin_name = "marksman"
local cmd = { bin_name, "server" }

return {
  cmd = cmd,
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".marksman.toml", ".git" },
}
