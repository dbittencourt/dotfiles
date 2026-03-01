-- load mini.icons first as it is used by many plugins
vim.pack.add({ { src = "https://github.com/nvim-mini/mini.icons" } })
local mini_icons = require("mini.icons")
mini_icons.setup()
-- mock nvim-web-devicons to use mini.icons instead
mini_icons.mock_nvim_web_devicons()

-- load all plugins under plugins directory
local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local files = vim.fn.readdir(plugins_dir)

for _, file in ipairs(files) do
	if file:match("%.lua$") then
		local plugin = file:sub(1, -5)
		require("plugins." .. plugin)
	end
end
