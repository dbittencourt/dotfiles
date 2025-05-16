return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})

    vim.keymap.set("n", "<leader>i", function()
      harpoon:list():add()
    end, { desc = "Add file to harpoon" })

    vim.keymap.set("n", "<leader>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "List files on harpoon" })

    vim.keymap.set("n", "<leader>7", function()
      harpoon:list():select(1)
    end, { desc = "Open harpoon 1st entry" })

    vim.keymap.set("n", "<leader>8", function()
      harpoon:list():select(2)
    end, { desc = "Open harpoon 2nd entry" })

    vim.keymap.set("n", "<leader>9", function()
      harpoon:list():select(3)
    end, { desc = "Open harpoon 3rd entry" })

    vim.keymap.set("n", "<leader>0", function()
      harpoon:list():select(4)
    end, { desc = "Open harpoon 4th entry" })
  end,
}
