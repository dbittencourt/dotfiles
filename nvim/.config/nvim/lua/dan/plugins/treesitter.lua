return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      highlight = { enable = true }, -- enable syntax highlight
      indent = { enable = true }, -- enable indentation
      -- enable autotagging with nvim-ts-autotag plugin
      autotag = { enable = true },
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "angular",
        "css",
        "scss",
        "dockerfile",
        "gitignore",
        "html",
        "lua",
        "sql",
        "terraform",
        "yaml",
        "markdown",
        "markdown_inline",
        "bash",
        "vim",
        "vimdoc", -- fix errors when using :help <anything>
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
