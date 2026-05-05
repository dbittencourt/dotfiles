local terms = { "term-git", "term-server", "term-ai" }

local function is_job_alive(buf)
	if buf <= 0 or vim.bo[buf].buftype ~= "terminal" then
		return false
	end

	local job = vim.bo[buf].channel
	return job > 0 and vim.fn.jobwait({ job }, 0)[1] == -1
end

local function term_win(buf)
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_buf(win) == buf then
			return win
		end
	end

	return nil
end

local function hide_terms(except)
	for _, name in ipairs(terms) do
		local buf = vim.fn.bufnr(name)
		local win = buf > 0 and buf ~= except and term_win(buf)

		if win then
			pcall(vim.api.nvim_win_hide, win)
		end
	end
end

local function get_term(name, cmd, toggle)
	local buf = vim.fn.bufnr(name)

	if buf > 0 and not is_job_alive(buf) then
		pcall(vim.api.nvim_buf_delete, buf, { force = true })
		buf = -1
	end

	local win = buf > 0 and term_win(buf)
	if toggle and win then
		hide_terms(nil)
		return nil
	end

	hide_terms(buf)

	if win then
		vim.api.nvim_set_current_win(win)
	elseif buf > 0 then
		vim.api.nvim_cmd({ cmd = "split", mods = { split = "belowright" } }, {})
		vim.api.nvim_win_set_buf(0, buf)
	else
		vim.api.nvim_cmd({ cmd = "new", mods = { split = "belowright" } }, {})
		vim.fn.jobstart(cmd or "fish", { term = true })
		vim.api.nvim_buf_set_name(0, name)

		buf = vim.api.nvim_get_current_buf()
		vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = buf, nowait = true })
		vim.keymap.set("t", "<C-\\>", function()
			local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
			vim.api.nvim_feedkeys(esc, "n", false)
		end, { buffer = buf, desc = "Feed esc in terminal mode using <C-\\>" })
	end

	pcall(vim.api.nvim_win_set_height, 0, math.max(8, math.floor(vim.o.lines / 3)))
	return vim.bo[0].channel
end

vim.keymap.set("n", "<leader>tg", function()
	get_term("term-git", nil, true)
end, { desc = "Toggle git terminal" })

vim.keymap.set("n", "<leader>ts", function()
	get_term("term-server", nil, true)
end, { desc = "Toggle server terminal" })

vim.keymap.set("n", "<leader>ta", function()
	get_term("term-ai", "codex", true)
end, { desc = "Toggle AI terminal" })

vim.keymap.set("x", "<leader>av", function()
	local buf = vim.fn.bufnr("term-ai")
	if buf == -1 or not is_job_alive(buf) then
		vim.notify("AI terminal is not running", vim.log.levels.ERROR)
		return
	end

	local mode = vim.fn.visualmode()
	if mode == "" then
		return
	end
	local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })
	local text = table.concat(lines, "\n") .. "\n"

	local job = get_term("term-ai", "codex", false)
	vim.api.nvim_chan_send(job, text)
	vim.api.nvim_cmd({ cmd = "startinsert" }, {})
end, { desc = "Send selection to AI terminal" })

vim.api.nvim_create_autocmd("TermLeave", {
	group = vim.api.nvim_create_augroup("dbitt/terminal", { clear = true }),
	desc = "Reload buffers when leaving terminal",
	pattern = "*",
	callback = function()
		vim.api.nvim_cmd({ cmd = "checktime" }, {})
	end,
})
