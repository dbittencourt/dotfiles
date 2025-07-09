-- install with: npm install -g @angular/language-server

-- angular requires a node_modules directory to probe for in order to use
-- your projects configured versions.
local root_dir = vim.fn.getcwd()
local node_modules_dir =
  vim.fs.find("node_modules", { path = root_dir, upward = true })[1]
local project_root = node_modules_dir and vim.fs.dirname(node_modules_dir)
  or "?"

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

  angular_core_version = angular_core_version
    and angular_core_version:match("%d+%.%d+%.%d+")

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
    "htmlangular",
  },
  root_markers = { "angular.json" },
}
