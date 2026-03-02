local function is_job_alive(buf)
	local job = vim.b[buf].terminal_job_id
	return job and vim.fn.jobwait({ job }, 0)[1] == -1
end

local function get_term(name, cmd, split, toggle)
	local buf = vim.fn.bufnr(name)
	local alive = buf > 0 and vim.bo[buf].buftype == "terminal" and is_job_alive(buf)

	if alive then
		local wins = vim.fn.win_findbuf(buf)
		local curr_tab = vim.api.nvim_get_current_tabpage()
		for _, win in ipairs(wins) do
			if vim.api.nvim_win_get_tabpage(win) == curr_tab then
				if toggle then
					vim.api.nvim_win_close(win, true)
					return nil
				end
				vim.api.nvim_set_current_win(win)
				return vim.b[buf].terminal_job_id
			end
		end

		if #wins > 0 then
			vim.api.nvim_set_current_win(wins[1])
			return vim.b[buf].terminal_job_id
		end
	elseif buf > 0 then
		pcall(vim.api.nvim_buf_delete, buf, { force = true })
	end

	local mods = split and { vertical = true, split = "belowright" } or { tab = -1 }
	vim.api.nvim_cmd({
		cmd = alive and "sbuffer" or (split and "new" or "tabnew"),
		args = alive and { buf } or nil,
		mods = mods,
	}, {})

	if split then
		vim.api.nvim_win_set_width(0, math.floor(vim.o.columns / 3))
	end

	if not alive then
		vim.fn.termopen(cmd or "fish")
		vim.cmd.file(name)
	end

	return vim.b[0].terminal_job_id
end

vim.keymap.set("n", "<leader>tg", function()
	get_term("term-git")
end, { desc = "Open git terminal" })

vim.keymap.set("n", "<leader>ts", function()
	get_term("term-server")
end, { desc = "Open server terminal" })

vim.keymap.set("n", "<leader>ta", function()
	if get_term("term-ai", "copilot", true, true) then
		vim.cmd("startinsert")
	end
end, { desc = "Toggle AI terminal" })

vim.keymap.set("x", "<leader>av", function()
	local buf = vim.fn.bufnr("term-ai")
	if buf == -1 or not is_job_alive(buf) then
		vim.notify("AI terminal is not running", vim.log.levels.ERROR)
		return
	end

	local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.visualmode() })
	local text = table.concat(lines, "\n") .. "\n"

	local job_id = get_term("term-ai")
	vim.api.nvim_chan_send(job_id, text)
	vim.cmd("startinsert")
end, { desc = "Send selection to AI terminal" })

local term_group = vim.api.nvim_create_augroup("dbitt/terminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
	group = term_group,
	desc = "Map <esc> to exit terminal mode",
	callback = function(args)
		vim.keymap.set("t", "<C-\\>", function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
		end, { desc = "Feed esc in terminal mode using <C-\\>" })

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
