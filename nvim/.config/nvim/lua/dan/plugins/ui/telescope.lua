return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopeResults",
      callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
          vim.fn.matchadd("TelescopeParent", "\t\t.*$")
          vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
      end,
    })

    telescope.setup({
      defaults = {
        -- display filename followed by path
        path_display = {
          filename_first = {
            reverse_directories = false,
          },
        },

        -- display prompt and results at the top
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },

        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-b>"] = actions.delete_buffer,
          },
        },
      },
      pickers = {
        find_files = {
          previewer = false,
          theme = "dropdown",
        },
        lsp_references = {
          show_line = false,
        },
      },
    })

    telescope.load_extension("fzf")

    local keymap = vim.keymap

    keymap.set(
      "n",
      "<leader>ff",
      builtin.find_files,
      { desc = "Fuzzy find files in cwd" }
    )
    keymap.set(
      "n",
      "<leader>fb",
      builtin.buffers,
      { desc = "Show open buffers" }
    )
    keymap.set(
      "n",
      "<leader>fr",
      builtin.oldfiles,
      { desc = "Fuzzy find recent files" }
    )
    keymap.set(
      "n",
      "<leader>fs",
      builtin.live_grep,
      { desc = "Find string in cwd" }
    )
    keymap.set(
      "n",
      "<leader>fc",
      builtin.grep_string,
      { desc = "Find string under cursor in cwd" }
    )
  end,
}
