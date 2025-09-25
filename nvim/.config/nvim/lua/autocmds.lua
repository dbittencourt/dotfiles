vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("dbitt/quick_close", { clear = true }),
	desc = "Close with <q>",
	pattern = { "help", "man", "qf", "scratch" },
	callback = function(args)
		vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = args.buf })
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("dbitt/yank_highlight", { clear = true }),
	desc = "Highlight on yank",
	callback = function()
		vim.hl.on_yank({ timeout = 250, higroup = "Visual" })
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("dbitt/spell_on", { clear = true }),
	desc = "Turn on spell check for markdown and text files",
	pattern = { "text", "tex", "markdown", "gitcommit" },
	callback = function()
		vim.opt_local.spell = true
	end,
})
