return {
  "ibhagwan/fzf-lua",
  config = function()
    local fzf = require("fzf-lua")
    local keymap = vim.keymap

    fzf.setup({
      "fzf-native",
      -- configure results format to name followed by directory
      defaults = {
        formatter = { "path.filename_first", 2 },
        -- open selection in new tab with ctrl+t
        actions = {
          ["ctrl-t"] = fzf.actions.file_tabedit,
        },
      },
      winopts = {
        preview = {
          layout = "vertical",
          vertical = "down:60%",
        },
      },
      -- restrict buffers from cwd to avoid confusion when switching projects
      oldfiles = {
        cwd_only = true,
        winopts = {
          preview = { hidden = true },
        },
      },
      files = {
        winopts = {
          preview = { hidden = true },
        },
        actions = {
          ["alt-i"] = { fzf.actions.toggle_ignore },
          ["alt-h"] = { fzf.actions.toggle_hidden },
        },
      },
      grep = {
        -- send all grep results to quicklist
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
      "<leader>fs",
      "<cmd>FzfLua live_grep<cr>",
      { desc = "Search string in cwd" }
    )
    keymap.set("n", "<leader>fg", function()
      vim.ui.input({
        prompt = "File Pattern: ",
        default = "*.",
      }, function(pattern)
        if not pattern or pattern == "" then
          return
        end

        fzf.live_grep({
          rg_opts = "-i --glob " .. vim.fn.shellescape(pattern),
        })
      end)
    end, { desc = "Search string in specific filetypes within cwd" })
    keymap.set(
      "n",
      "<leader>fc",
      "<cmd>FzfLua grep_cword<cr>",
      { desc = "Search word under cursor in cwd" }
    )
    keymap.set(
      "v",
      "<leader>fv",
      "<cmd>FzfLua grep_visual<cr>",
      { desc = "Search selection in cwd" }
    )
  end,
}
