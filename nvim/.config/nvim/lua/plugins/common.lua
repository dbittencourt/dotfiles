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
  { -- git plugin
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      vim.opt.fillchars = vim.opt.fillchars + "diff:╱"
      local opts = { noremap = true, silent = true }
      opts.desc = "Toggle git blame on buffer"
      vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", opts)
      opts.desc = "Open file history on git"
      vim.keymap.set("n", "<leader>gh", "<cmd>0Gllog<cr>", opts)
    end,
  },
  { -- neovim session
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        auto_restore = false,
      })

      vim.keymap.set(
        "n",
        "<leader>ss",
        "<cmd>SessionSave<CR>",
        { desc = "Save session for auto session root dir" }
      )
      vim.keymap.set(
        "n",
        "<leader>rs",
        "<cmd>SessionRestore<CR>",
        { desc = "Restore session for cwd" }
      )
    end,
  },
}
