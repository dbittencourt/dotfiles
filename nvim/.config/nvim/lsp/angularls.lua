-- install with: npm install -g @angular/language-server

-- find the project root by looking for 'angular.json' first.
local angular_json_path = vim.fs.find("angular.json", {
	path = vim.fn.getcwd(),
	upward = true,
	type = "file",
})[1]

if not angular_json_path then
	return {}
end

local project_root = vim.fs.dirname(angular_json_path)

local function get_probe_dir()
	return project_root and (project_root .. "/node_modules") or ""
end

local function get_angular_core_version()
	if not project_root then
		return ""
	end

	local package_json = project_root .. "/package.json"
	if not vim.uv.fs_stat(package_json) then
		return ""
	end

	local contents = io.open(package_json):read("*a")
	local json = vim.json.decode(contents)
	if not json.dependencies then
		return ""
	end

	local angular_core_version = json.dependencies["@angular/core"]

	angular_core_version = angular_core_version and angular_core_version:match("%d+%.%d+%.%d+")

	return angular_core_version
end

local default_probe_dir = get_probe_dir()
local default_angular_core_version = get_angular_core_version()

return {
	cmd = {
		"ngserver",
		"--stdio",
		"--tsProbeLocations",
		default_probe_dir,
		"--ngProbeLocations",
		default_probe_dir,
		"--angularCoreVersion",
		default_angular_core_version,
	},
	filetypes = {
		"typescript",
		"htmlangular",
	},
	root_markers = { "angular.json" },
}
