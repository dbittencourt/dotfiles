local session_dir = vim.fn.stdpath("data") .. "/session"

if vim.fn.isdirectory(session_dir) == 0 then
	vim.fn.mkdir(session_dir, "p")
end

local function get_session_path()
	local name = vim.fn.getcwd():gsub("/", "%%2F") .. ".vim"
	return session_dir .. "/" .. name
end

vim.keymap.set("n", "<leader>ss", function()
	local path = get_session_path()
	vim.cmd("mksession! " .. vim.fn.fnameescape(path))
	vim.notify("Session saved")
end, { desc = "Save session for current directory" })

vim.keymap.set("n", "<leader>rs", function()
	local path = get_session_path()
	if vim.loop.fs_stat(path) then
		vim.cmd("source " .. vim.fn.fnameescape(path))
		vim.notify("Session restored")
	else
		vim.notify("Session not found for current directory.", vim.log.levels.WARN)
	end
end, { desc = "Restore session for current directory" })
