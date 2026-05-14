vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = true

vim.g.dotnet_errors_only = true
vim.g.dotnet_show_project_file = false
vim.cmd("compiler dotnet")

local function get_project_root()
	local bufname = vim.api.nvim_buf_get_name(0)
	local start_dir = bufname ~= "" and vim.fs.dirname(bufname) or vim.uv.cwd() or vim.fn.getcwd()

	local sln = vim.fs.find(function(name)
		return name:match("%.sln$") ~= nil
	end, { path = start_dir, upward = true, type = "file" })[1]
	if sln then
		return vim.fs.dirname(sln)
	end

	local csproj = vim.fs.find(function(name)
		return name:match("%.csproj$") ~= nil
	end, { path = start_dir, upward = true, type = "file" })[1]

	return csproj and vim.fs.dirname(csproj) or nil
end

local function run_dotnet_test()
	local project_root = get_project_root()
	if not project_root then
		print("Error: Not in a .NET project.")
		return
	end

	print("Running dotnet test from: " .. project_root)

	local command = { "dotnet", "test", "--logger", "console;verbosity=normal" }
	vim.system(command, {
		cwd = project_root,
		text = true,
	}, function(result)
		vim.schedule(function()
			if result.code == 0 then
				print("Dotnet test successful! No errors found.")
				return
			end

			local output = table.concat({ result.stdout or "", result.stderr or "" }, "\n")
			local test_output = vim.split(output, "\n", { plain = true, trimempty = true })

			local quickfix_items = {}
			local last_test_name = nil

			for _, line in ipairs(test_output) do
				local test_name = line:match("^  Failed (.+) %[%d+ m?s%]$")
				if test_name then
					last_test_name = test_name
				end

				local abs_path, line_num = line:match(" in (.+%.cs):line (%d+)")
				if last_test_name and abs_path and line_num then
					local rel_path = vim.fs.relpath(project_root, abs_path) or abs_path
					local name = last_test_name:match("([^.]+)$") or last_test_name

					table.insert(quickfix_items, {
						filename = rel_path,
						lnum = tonumber(line_num),
						text = string.format("Test failed: %s", name),
					})
					last_test_name = nil
				end
			end

			if #quickfix_items == 0 then
				print("Dotnet test failed, but no parsable errors were found.")
				return
			end

			vim.fn.setqflist({}, "r", {
				title = "dotnet test failures",
				items = quickfix_items,
			})

			print("Found " .. #quickfix_items .. " test failures.")
			vim.cmd("copen")
		end)
	end)
end

vim.keymap.set("n", "<leader>pt", run_dotnet_test, {
	buffer = true,
	silent = true,
	desc = "Run tests",
})
