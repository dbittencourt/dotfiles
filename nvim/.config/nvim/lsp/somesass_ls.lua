-- sass config
-- install with: npm i -g some-sass-language-server

---@type vim.lsp.Config
return {
  name = "somesass_ls",
  cmd = { "some-sass-language-server", "--stdio" },
  filetypes = { "scss", "sass" },
  root_markers = { ".git", ".package.json" },
  settings = {
    somesass = {
      suggestAllFromOpenDocument = true,
    },
  },
}
