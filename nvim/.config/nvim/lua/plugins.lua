require("mini")

local config_path = vim.fn.stdpath("config") .. "/lua/plugins"
local files = vim.fn.readdir(config_path)

for _, file in ipairs(files) do
	if file:match("%.lua$") then
		local plugin = file:sub(1, -5)
		require("plugins." .. plugin)
	end
end
