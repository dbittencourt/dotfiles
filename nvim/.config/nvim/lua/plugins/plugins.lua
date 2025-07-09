return {
  -- common lua functions used by many plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  { -- automatically close tags
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
