return {
  -- common lua functions used by many plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  { -- automatically close tags
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
  { -- navigate through undo history
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undo Tree" },
    },
  },
}
