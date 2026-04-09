-- load mini.icons first as it is used by many plugins
vim.pack.add({ { src = "https://github.com/nvim-mini/mini.icons" } })
local mini_icons = require("mini.icons")
mini_icons.setup()
-- mock nvim-web-devicons to use mini.icons instead
mini_icons.mock_nvim_web_devicons()

-- load all plugins under plugins directory
local plugins_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua/plugins")

vim.iter(vim.fs.dir(plugins_dir))
	:map(function(name)
		return name:match("^(.*)%.lua$")
	end)
	:filter(function(name)
		return name ~= nil
	end)
	:each(function(name)
		require("plugins." .. name)
	end)
