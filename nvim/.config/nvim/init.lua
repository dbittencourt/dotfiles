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

require("autocmds")
require("diagnostics")
require("keymaps")
require("options")
require("plugins")
require("lsp")

-- enable new experimental ui2, so you don't get the annoying "press any key" warning
require("vim._core.ui2").enable({})
