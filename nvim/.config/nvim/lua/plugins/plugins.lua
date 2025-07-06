return {
  -- common lua functions used by many plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  { -- set ruler at column 80
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
  { -- automatically close tags
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
