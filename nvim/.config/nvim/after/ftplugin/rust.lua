vim.cmd("compiler cargo")

local cargo_test_efm = table.concat({
	"%-G  left:%.%#",
	"%-G right:%.%#",
	"%-Gnote: run with `RUST_BACKTRACE=%.%#",
	"%-Gerror: test failed%.%#",
	"%-Gwarning: build failed%.%#",
	"%Ethread '%m' %.%# panicked at %f:%l:%c:",
	"%Ethread '%m' panicked at %f:%l:%c:",
}, ",")

vim.bo.errorformat = cargo_test_efm .. "," .. vim.bo.errorformat .. ",%-G%.%#"

local function run_cargo_test()
	local shellpipe = vim.o.shellpipe
	vim.o.shellpipe = ">%s 2>&1"

	local ok, err = pcall(vim.cmd.make, {
		args = { "test" },
		mods = { silent = true },
	})
	local failed = vim.v.shell_error ~= 0
	vim.o.shellpipe = shellpipe

	if not ok then
		error(err)
	end

	if failed then
		vim.cmd.copen()
	else
		vim.cmd.cclose()
		vim.notify("Tests passed")
	end
end

vim.keymap.set("n", "<leader>pb", "<cmd>make build<cr>", {
	buffer = true,
	silent = true,
	desc = "Build project",
})

vim.keymap.set("n", "<leader>pt", run_cargo_test, {
	buffer = true,
	silent = true,
	desc = "Run tests",
})
