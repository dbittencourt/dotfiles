return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({
      settings = {
        save_on_toggle = true,
      },
    })

    vim.keymap.set("n", "<leader>H", function()
      harpoon:list():add()
    end, { desc = "Add file to harpoon list" })

    vim.keymap.set("n", "<leader>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "List files on harpoon" })

    -- map righthand numbers to 1..5 entries
    local entries = { 6, 7, 8, 9, 0 }
    for i, key in ipairs(entries) do
      vim.keymap.set("n", "<leader>" .. key, function()
        require("harpoon"):list():select(i)
      end, { desc = "Harpoon to File " .. i })
    end
  end,
}
