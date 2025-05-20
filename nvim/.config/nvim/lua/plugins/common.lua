return {
  -- common lua functions used by many plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  -- tmux integration
  { "christoomey/vim-tmux-navigator" },
  { -- install lsps/formatters/linters/daps
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
      })
    end,
  },
  -- set ruler at column 80
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      disabled_filetypes = {
        "help",
        "lazy",
        "mason",
        "lspinfo",
        "checkhealth",
      },
    },
  },
  -- automatically close tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
