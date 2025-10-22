local function get_project_root()
	local start_dir = vim.fn.getcwd()

	local sln_files = vim.fn.glob(start_dir .. "/*.sln", true, true)
	if sln_files and #sln_files > 0 then
		return vim.fs.dirname(sln_files[1])
	end

	local csproj_files = vim.fn.glob(start_dir .. "/*.csproj", true, true)
	if csproj_files and #csproj_files > 0 then
		return vim.fs.dirname(csproj_files[1])
	end

	return nil
end

local function run_dotnet_test()
	local project_root = get_project_root()
	if not project_root then
		print("Error: Not in a .NET project.")
		return
	end

	print("Running dotnet test from: " .. project_root)

	local command = { "dotnet", "test", "--logger", "console;verbosity=normal" }
	local test_output = {}

	vim.fn.jobstart(command, {
		cwd = project_root,
		on_stdout = function(_, data, _)
			for _, line in ipairs(data) do
				table.insert(test_output, line)
			end
		end,
		on_stderr = function(_, data, _)
			for _, line in ipairs(data) do
				table.insert(test_output, line)
			end
		end,
		on_exit = function(_, exit_code, _)
			if exit_code == 0 then
				print("Dotnet test successful! No errors found.")
				return
			end

			local quickfix_items = {}
			local last_test_name = nil

			for _, line in ipairs(test_output) do
				local test_name = line:match("^  Failed (.+) %[%d+ m?s%]$")
				if test_name then
					last_test_name = test_name
				end

				local abs_path, line_num = line:match(" in (.+%.cs):line (%d+)")
				if last_test_name and abs_path and line_num then
					local rel_path = abs_path:gsub(project_root .. "/", "")
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
		end,
	})
end

local setup_compiler = function()
	vim.cmd("compiler dotnet")
	-- normal dotnet build behavior spins a lot of processes every time you trigger a build
	-- if you dont set MSBUILDDISABLENODEREUSE=1 environment variable, uncomment line bellow
	-- vim.o.makeprg = "dotnet build /nodeReuse:false"
	vim.g.dotnet_errors_only = true
	vim.g.dotnet_show_project_file = false
end

local dotnet_group = vim.api.nvim_create_augroup("dbitt/dotnet", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = dotnet_group,
	callback = function()
		setup_compiler()
		if get_project_root() then
			vim.keymap.set("n", "<leader>td", run_dotnet_test, {
				noremap = true,
				silent = true,
				desc = "Run dotnet test and populate quickfix",
			})
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = dotnet_group,
	pattern = "cs",
	callback = function()
		setup_compiler()
	end,
})
