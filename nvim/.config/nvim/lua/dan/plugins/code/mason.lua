return {
  "williamboman/mason.nvim",
  dependencies = {
    -- ensure lsps are installed by mason
    "williamboman/mason-lspconfig.nvim",
    -- ensure formatters and linters are installed by mason
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "angularls",
        "cssls",
        "eslint",
        "html",
        "lua_ls",
        "marksman",
        "rust_analyzer",
        "tsserver",
      },

      -- auto-install configured servers with lspconfig
      automatic_installation = true,
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "prettier",
        "stylua",
      },
    })
  end,
}
