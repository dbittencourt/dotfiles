return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = {
        "~/",
        "~/Downloads",
        "~/Documents",
        "~/Desktop/",
      },
    })

    local keymap = vim.keymap

    keymap.set(
      "n",
      "<leader>ss",
      "<cmd>SessionSave<CR>",
      { desc = "Save session for auto session root dir" }
    )
    keymap.set(
      "n",
      "<leader>rs",
      "<cmd>SessionRestore<CR>",
      { desc = "Restore session for cwd" }
    )
  end,
}
