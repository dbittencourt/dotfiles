return {
  "ibhagwan/fzf-lua",
  config = function()
    local fzf = require("fzf-lua")
    local keymap = vim.keymap

    fzf.setup({
      -- disable icon rendering to improve performance
      "max-perf",
      -- configure results format to name followed by directory
      defaults = {
        formatter = { "path.filename_first", 2 },
      },
      -- disable highlights on directory data to avoid issues with disable ansi
      hls = {
        dir_part = false,
      },
      -- restricted buffers from cwd to avoid confusion when switching projects
      oldfiles = {
        cwd_only = true,
      },
      -- send all grep result to quicklist
      grep = {
        actions = {
          ["ctrl-q"] = {
            fn = fzf.actions.file_edit_or_qf,
            prefix = "select-all+",
          },
        },
      },
    })

    fzf.register_ui_select()

    keymap.set(
      "n",
      "<leader>ff",
      "<cmd>FzfLua files<cr>",
      { desc = "Fuzzy find files in cwd" }
    )
    keymap.set(
      "n",
      "<leader>fb",
      "<cmd>FzfLua buffers<cr>",
      { desc = "Show open buffers" }
    )
    keymap.set(
      "n",
      "<leader>fr",
      "<cmd>FzfLua oldfiles<cr>",
      { desc = "Fuzzy find recent files" }
    )
    keymap.set(
      "n",
      "<leader>fs",
      "<cmd>FzfLua live_grep<cr>",
      { desc = "Search string in cwd" }
    )
    keymap.set(
      "n",
      "<leader>fc",
      "<cmd>FzfLua grep_cword<cr>",
      { desc = "Search word under cursor in cwd" }
    )
    keymap.set(
      "n",
      "<leader>fl",
      "<cmd>FzfLua blines<cr>",
      { desc = "Fuzzy find in current buffer" }
    )
    keymap.set(
      "v",
      "<leader>fv",
      "<cmd>FzfLua grep_visual<cr>",
      { desc = "Search selection in cwd" }
    )
  end,
}
