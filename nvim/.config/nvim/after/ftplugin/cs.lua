vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = true

vim.g.dotnet_errors_only = true
vim.g.dotnet_show_project_file = false
vim.cmd("compiler dotnet")

local dotnet_test_efm = table.concat({
	"%E  Failed %m [%*[^]]]",
	"%Z%\\s%#at %.%# in %f:line %l",
	"%C%.%#",
	"%E%f : error %m",
	"%W%f : warning %m",
}, ",")

vim.bo.errorformat = dotnet_test_efm .. "," .. vim.bo.errorformat

local function dotnet_target()
	local bufname = vim.api.nvim_buf_get_name(0)
	local start_dir = bufname ~= "" and vim.fs.dirname(bufname) or vim.uv.cwd() or vim.fn.getcwd()

	local sln = vim.fs.find(function(name)
		return name:match("%.sln$") ~= nil
	end, { path = start_dir, upward = true, type = "file" })[1]
	if sln then
		return sln
	end

	return vim.fs.find(function(name)
		return name:match("%.csproj$") ~= nil
	end, { path = start_dir, upward = true, type = "file" })[1]
end

local function run_dotnet_test()
	local target = dotnet_target()
	if not target then
		vim.notify("Not in a .NET project.", vim.log.levels.ERROR)
		return
	end

	local makeprg = vim.bo.makeprg
	local shellpipe = vim.o.shellpipe

	vim.bo.makeprg = table.concat({
		"dotnet",
		"test",
		vim.fn.shellescape(target),
		"-nologo",
		"-p:TestingPlatformShowTestsFailure=true",
		"--logger",
		vim.fn.shellescape("console;verbosity=normal"),
	}, " ")
	vim.o.shellpipe = ">%s 2>&1"

	local ok, err = pcall(vim.cmd.make, {
		mods = { silent = true },
	})
	local failed = vim.v.shell_error ~= 0

	vim.bo.makeprg = makeprg
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

vim.keymap.set("n", "<leader>pb", "<cmd>make<cr>", {
	buf = 0,
	silent = true,
	desc = "Build project",
})

vim.keymap.set("n", "<leader>pt", run_dotnet_test, {
	buf = 0,
	silent = true,
	desc = "Run tests",
})
