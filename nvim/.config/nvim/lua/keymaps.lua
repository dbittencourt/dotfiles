vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap

map.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
map.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
map.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map.set(
  "n",
  "<leader>tf",
  "<cmd>tabnew %<CR>",
  { desc = "Open current buffer in new tab" }
)
map.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
