---@brief
---
--- https://github.com/swiftlang/sourcekit-lsp
---
--- Language server for Swift and C/C++/Objective-C.

local function root_pattern(bufnr, patterns)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	local match = vim.fs.find(patterns, { path = fname, upward = true })[1]
	if match then
		return vim.fs.dirname(match)
	end
end

local function root_suffix(bufnr, suffixes)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	local match = vim.fs.find(function(name)
		for _, suffix in ipairs(suffixes) do
			if name:sub(-#suffix) == suffix then
				return true
			end
		end
		return false
	end, { path = fname, upward = true, type = "directory" })[1]
	if match then
		return vim.fs.dirname(match)
	end
end

---@type vim.lsp.Config
return {
	cmd = { "sourcekit-lsp" },
	filetypes = { "swift", "objc", "objcpp", "c", "cpp" },
	root_dir = function(bufnr, on_dir)
		on_dir(
			root_pattern(bufnr, { "buildServer.json" })
				or root_suffix(bufnr, { ".bsp", ".xcodeproj", ".xcworkspace" })
				-- better to keep it at the end, because some modularized apps contain multiple Package.swift files
				or root_pattern(bufnr, { "compile_commands.json", "Package.swift" })
				or root_pattern(bufnr, { ".git" })
		)
	end,
	get_language_id = function(_, ftype)
		local t = { objc = "objective-c", objcpp = "objective-cpp" }
		return t[ftype] or ftype
	end,
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
		textDocument = {
			diagnostic = {
				dynamicRegistration = true,
				relatedDocumentSupport = true,
			},
		},
	},
}
