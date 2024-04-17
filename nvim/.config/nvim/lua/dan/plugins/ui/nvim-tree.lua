return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local nvimtree = require("nvim-tree")

    -- disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      -- show current file on nvim-tree
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      view = {
        width = 30,
        adaptive_size = true,
        centralize_selection = true,
      },
      -- disable window_picker for explorer to work well with window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = { ignore = false },
    })

    -- set keymaps
    local keymap = vim.keymap
    -- toggle file explorer
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>")
    -- toggle file explorer on current file
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>")
    -- collapse file explorer
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>")
    -- refresh file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>")
  end,
}
