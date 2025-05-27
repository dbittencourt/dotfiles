return {
  -- common lua functions used by many plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  -- tmux integration
  { "christoomey/vim-tmux-navigator" },
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
  { -- force good vim habits
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      allow_different_key = true,
      hints = {
        ["[dcyvV][ia][%(%)]"] = {
          message = function(keys)
            return "Use " .. keys:sub(1, 2) .. "b instead of " .. keys
          end,
          length = 3,
        },
      },
    },
  },
  { -- automatically close tags
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
