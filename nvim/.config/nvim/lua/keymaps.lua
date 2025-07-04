vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap

map.set(
  "n",
  "<leader>nh",
  "<cmd>nohl<cr>",
  { desc = "Clear search highlights" }
)

-- window management
map.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map.set("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close current split" })
map.set("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "Open new tab" })
map.set("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "Close current tab" })
map.set(
  "n",
  "<leader>tf",
  "<cmd>tabnew %<cr>",
  { desc = "Open current buffer in new tab" }
)

-- selection helpers
map.set("n", "<leader>ya", "0ggvG$y", { desc = "Copy buffer content" })
map.set("n", "<leader>yd", "0ggvG$d", { desc = "Delete buffer content" })

-- disable arrow keys to make life harder
map.set({ "n", "v", "i" }, "<up>", "<nop>", { noremap = true })
map.set({ "n", "v", "i" }, "<down>", "<nop>", { noremap = true })
map.set({ "n", "v", "i" }, "<left>", "<nop>", { noremap = true })
map.set({ "n", "v", "i" }, "<right>", "<nop>", { noremap = true })
