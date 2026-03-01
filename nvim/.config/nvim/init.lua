require("autocmds")
require("diagnostics")
require("keymaps")
require("lsp")
require("options")
require("plugins")

-- disable built-in plugins
local disabled_plugins = {
	"gzip",
	"netrw",
	"netrwPlugin",
	"remote_plugins",
	"tarPlugin",
	"tohtml",
	"tutor",
	"vimballPlugin",
	"zipPlugin",
}

for _, plugin in ipairs(disabled_plugins) do
	vim.g["loaded_" .. plugin] = 1
end
