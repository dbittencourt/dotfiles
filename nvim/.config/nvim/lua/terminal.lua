local function is_job_alive(buf)
	local job = vim.b[buf] and vim.b[buf].terminal_job_id
	if not job then
		return false
	end
	-- -1 means job is still running
	return vim.fn.jobwait({ job }, 0)[1] == -1
end

local function get_term(name, cmd)
	local buf = vim.fn.bufnr(name)

	if buf > 0 and vim.bo[buf].buftype == "terminal" and is_job_alive(buf) then
		local wins = vim.fn.win_findbuf(buf)
		if #wins > 0 then
			local win = wins[1]
			local tab = vim.api.nvim_win_get_tabpage(win)
			vim.api.nvim_set_current_tabpage(tab)
			vim.api.nvim_set_current_win(win)
		else
			vim.cmd("tab sbuffer " .. buf)
		end

		vim.cmd.startinsert()
		return
	end

	-- remove conflicting/dead buffer if present
	if buf > 0 and vim.api.nvim_buf_is_valid(buf) then
		pcall(vim.api.nvim_buf_delete, buf, { force = true })
	end

	vim.cmd.tabnew()
	buf = vim.api.nvim_get_current_buf()
	vim.fn.termopen(cmd or "fish")
	vim.cmd.file(name)
	vim.cmd.startinsert()
end

vim.keymap.set("n", "<leader>ta", function()
	get_term("term-ai")
end, { desc = "Open AI terminal" })

vim.keymap.set("n", "<leader>ts", function()
	get_term("term-server")
end, { desc = "Open server terminal" })

vim.keymap.set("t", "<C-\\>", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Feed esc in terminal mode using <C-\\>" })

local term_group = vim.api.nvim_create_augroup("dbitt/terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = term_group,
	desc = "Map <esc> to exit terminal mode",
	callback = function(args)
		vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = args.buf, nowait = true })
	end,
})

vim.api.nvim_create_autocmd("TermLeave", {
	group = term_group,
	desc = "Reload buffers when leaving terminal",
	pattern = "*",
	callback = function()
		vim.cmd.checktime()
	end,
})
