vim.opt_local.makeprg = "cargo build"

vim.keymap.set("n", "<leader>pt", "<cmd>Ctest<cr>", {
	buffer = true,
	silent = true,
	desc = "Run tests",
})
