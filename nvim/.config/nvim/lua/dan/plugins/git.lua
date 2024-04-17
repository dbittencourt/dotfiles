return {
  "sindrets/diffview.nvim",
  dependencies = {
    "tpope/vim-fugitive",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", opts)
    vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_stash<cr>", opts)
    vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", opts)
    vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", opts)

    vim.opt.fillchars = vim.opt.fillchars + "diff:╱"
    require("diffview").setup({
      {
        use_icons = true,
        show_help_hints = false,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
        },
        hooks = {
          -- fix for auto-folding
          diff_buf_read = function(bufnr)
            vim.cmd("norm! gg]ckzt") -- Set cursor on the first hunk
          end,
          diff_buf_win_enter = function(bufnr)
            vim.opt_local.foldlevel = 99
          end,
        },
      },
    })
  end,
}
