vim.pack.add({ { src = "https://github.com/tpope/vim-fugitive" } })

local toggle_status = function()
	local win = vim.iter(vim.api.nvim_list_wins()):find(function(w)
		local ok, v = pcall(vim.api.nvim_buf_get_var, vim.api.nvim_win_get_buf(w), "fugitive_status")
		return ok and v
	end)
	if win then
		vim.api.nvim_win_close(win, false)
	else
		vim.cmd("Git")
	end
end

vim.keymap.set("n", "<leader>gs", toggle_status, { desc = "Toggle git status" })
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Toggle git blame on buffer" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", { desc = "Open a diff view" })
vim.keymap.set("n", "<leader>gD", "<cmd>diffoff | only<cr>", { desc = "Close diff view" })
vim.keymap.set("n", "<leader>gl", "<cmd>0Gllog<cr>", { desc = "Open file git history" })
vim.keymap.set("n", "<leader>go", "<cmd>diffget //2<cr>", { desc = "Select ours version in git conflict" })
vim.keymap.set("n", "<leader>gt", "<cmd>diffget //3<cr>", { desc = "Select theirs version in git conflict" })
