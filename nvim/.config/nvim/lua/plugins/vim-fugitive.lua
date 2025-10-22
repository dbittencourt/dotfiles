return {
	"tpope/vim-fugitive",
	event = "VeryLazy",
	config = function()
		vim.opt.fillchars = vim.opt.fillchars + "diff:╱"

		local toggle_status = function()
			local fugitive_open = false
			-- iterate over all windows
			for _, winid in ipairs(vim.api.nvim_list_wins()) do
				local bufnr = vim.api.nvim_win_get_buf(winid)
				-- check for the fugitive_status buffer variable
				local success, is_fugitive_status = pcall(vim.api.nvim_buf_get_var, bufnr, "fugitive_status")

				if success and is_fugitive_status then
					-- if it is the fugitive window, close it
					vim.api.nvim_win_close(winid, false)
					fugitive_open = true
					break
				end
			end

			if not fugitive_open then
				vim.cmd("Git")
			end
		end

		vim.keymap.set("n", "<leader>gs", toggle_status, { desc = "Toggle git status" })
		vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Toggle git blame on buffer" })
		vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Open a horizontal diff split" })
		vim.keymap.set("n", "<leader>gh", "<cmd>0Gllog<cr>", { desc = "Open file git history" })
	end,
}
