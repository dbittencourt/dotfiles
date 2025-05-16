-- angular config
-- install with: npm install -g @angular/language-server
local angularls_path = vim.fn.expand("$MASON/packages/angular-language-server")
local cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations",
  angularls_path,
  "--ngProbeLocations",
  angularls_path .. "/node_modules/@angular/language-server",
  "--angularCoreVersion",
  angularls_path .. "/node_modules/@angular/language-server",
}

---@type vim.lsp.Config
return {
  filetypes = { "ts", "typescript", "htmlangular" },
  cmd = cmd,
  on_new_config = function(new_config, _)
    new_config.cmd = cmd
  end,
}
