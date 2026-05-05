local marks_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "marks")
local mark_cache = {}

local function project_mark_path()
	local cwd = vim.fs.normalize(vim.uv.cwd() or vim.fn.getcwd()):gsub("/", "%%2F")
	return vim.fs.joinpath(marks_dir, cwd .. ".json")
end

local function load_project_marks(path)
	local stat = vim.uv.fs_stat(path)
	if stat == nil then
		mark_cache[path] = nil
		return {}
	end

	local version = stat.size .. ":" .. stat.mtime.sec .. ":" .. stat.mtime.nsec
	local cached = mark_cache[path]
	if cached ~= nil and cached.version == version then
		return cached.marks
	end

	local ok, text = pcall(vim.fn.readblob, path)
	if not ok then
		vim.notify("Failed to read project marks: " .. text, vim.log.levels.WARN)
		return nil
	end

	if text == "" then
		local marks = {}
		mark_cache[path] = { marks = marks, version = version }
		return marks
	end

	local decode_ok, marks = pcall(vim.json.decode, text)
	if not decode_ok or type(marks) ~= "table" then
		local reason = decode_ok and "expected table" or tostring(marks)
		vim.notify("Invalid project marks " .. path .. ": " .. reason, vim.log.levels.WARN)
		return nil
	end

	mark_cache[path] = { marks = marks, version = version }
	return marks
end

local function save_project_marks(path, marks)
	local encode_ok, text = pcall(vim.json.encode, marks, { sort_keys = true })
	if not encode_ok then
		vim.notify("Failed to encode project marks: " .. text, vim.log.levels.ERROR)
		return false
	end

	local mkdir_ok, mkdir_result = pcall(vim.fn.mkdir, marks_dir, "p")
	if not mkdir_ok then
		vim.notify("Failed to create project marks dir: " .. mkdir_result, vim.log.levels.ERROR)
		return false
	end

	if mkdir_result == 0 then
		vim.notify("Failed to create project marks dir: " .. marks_dir, vim.log.levels.ERROR)
		return false
	end

	local write_ok, result = pcall(vim.fn.writefile, { text }, path, "b")
	if not write_ok then
		vim.notify("Failed to save project marks: " .. result, vim.log.levels.ERROR)
		return false
	end

	if result ~= 0 then
		vim.notify("Failed to save project marks: " .. path, vim.log.levels.ERROR)
		return false
	end

	local stat = vim.uv.fs_stat(path)
	if stat ~= nil then
		local version = stat.size .. ":" .. stat.mtime.sec .. ":" .. stat.mtime.nsec
		mark_cache[path] = { marks = marks, version = version }
	end

	return true
end

local function set_project_mark(slot)
	local path = project_mark_path()
	local marks = load_project_marks(path)
	if marks == nil then
		return
	end

	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("No file for project mark " .. slot, vim.log.levels.WARN)
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	marks[tostring(slot)] = {
		file = file,
		row = cursor[1],
		col = cursor[2],
	}

	if save_project_marks(path, marks) then
		vim.notify("Set project mark " .. slot)
	end
end

local function jump_project_mark(slot)
	local path = project_mark_path()
	local marks = load_project_marks(path)
	if marks == nil then
		return
	end

	local mark = marks[tostring(slot)]
	if mark == nil then
		vim.notify("Project mark " .. slot .. " not set", vim.log.levels.WARN)
		return
	end

	if
		type(mark) ~= "table"
		or type(mark.file) ~= "string"
		or mark.file == ""
		or type(mark.row) ~= "number"
		or type(mark.col) ~= "number"
	then
		vim.notify("Project mark " .. slot .. " is invalid", vim.log.levels.WARN)
		return
	end

	if vim.uv.fs_stat(mark.file) == nil then
		vim.notify("Project mark file missing: " .. mark.file, vim.log.levels.WARN)
		return
	end

	local edit_ok, edit_err = pcall(vim.api.nvim_cmd, {
		cmd = "edit",
		args = { mark.file },
		magic = { file = false, bar = false },
	}, {})
	if not edit_ok then
		vim.notify("Failed to open project mark: " .. edit_err, vim.log.levels.WARN)
		return
	end

	local last_row = vim.api.nvim_buf_line_count(0)
	local row = math.max(1, math.min(math.floor(mark.row), last_row))
	local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
	local col = math.max(0, math.min(math.floor(mark.col), #line))
	vim.api.nvim_win_set_cursor(0, { row, col })
end

for i = 1, 5 do
	vim.keymap.set("n", "<leader>s" .. i, function()
		set_project_mark(i)
	end, { desc = "Set project mark " .. i })

	vim.keymap.set("n", "<leader>m" .. i, function()
		jump_project_mark(i)
	end, { desc = "Jump project mark " .. i })
end
