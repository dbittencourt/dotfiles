vim.pack.add({ { src = "https://github.com/nvim-mini/mini.sessions" } })

-- neovim session management
local sessions = require("mini.sessions")
sessions.setup()
local function session_name()
	local name = vim.fn.getcwd():gsub("/", "%%2F") .. ".vim"
	return name
end
local function session_path()
	local session_dir = sessions.config.directory or (vim.fn.stdpath("data") .. "/session")
	return session_dir .. "/" .. session_name()
end

vim.keymap.set("n", "<leader>ss", function()
	sessions.write(session_name())
end, { desc = "Save session for current directory" })
vim.keymap.set("n", "<leader>rs", function()
	if vim.loop.fs_stat(session_path()) then
		sessions.read(session_name())
	else
		vim.notify("Session not found for current directory.", vim.log.levels.WARN)
	end
end, { desc = "Restore session for current directory" })
