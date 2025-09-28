local function get_term(name)
	local buf = vim.fn.bufnr(name)
	if buf > 0 and vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
		local wins = vim.fn.win_findbuf(buf)
		if #wins > 0 then
			local win = wins[1]
			local tab = vim.api.nvim_win_get_tabpage(win)
			vim.api.nvim_set_current_tabpage(tab)
			vim.api.nvim_set_current_win(win)
			return
		end

		vim.cmd("tab sbuffer " .. buf)
	else
		if buf > 0 then
			vim.cmd.bdelete({ bang = true, buf })
		end
		vim.cmd.tabnew()
		vim.cmd.terminal()
		vim.cmd.file(name)
	end
end

vim.keymap.set("n", "<leader>ta", function()
	get_term("term-ai")
end, { desc = "Open AI terminal" })

vim.keymap.set("n", "<leader>ts", function()
	get_term("term-server")
end, { desc = "Open server terminal" })

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("dbitt/terminal_escape", { clear = true }),
	desc = "Map <esc> to exit terminal mode",
	callback = function(args)
		vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = args.buf, nowait = true })
	end,
})
