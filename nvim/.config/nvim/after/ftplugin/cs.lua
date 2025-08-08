local build_command = table.concat({
	"dotnet clean --nologo -v quiet",
	"&& dotnet build --nologo -clp:NoSummary;GenerateFullPaths=true",
}, " ")

vim.opt.makeprg = build_command
vim.opt.errorformat = "%f(%l,%c): %t %n: %m"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.matchpairs = "(:),{:},[:],<:>"
