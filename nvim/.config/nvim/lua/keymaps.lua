vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap

map.set("n", "<leader>nh", "<cmd>nohl<cr>", { desc = "Clear search highlights" })
map.set("n", "<C-d>", "<C-d>zz", { desc = "Center screen after going down one page" })
map.set("n", "<C-u>", "<C-u>zz", { desc = "Center screen after going up one page" })

-- split management
map.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map.set("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close current split" })
map.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
map.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
map.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })

-- tab management
map.set("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "Open new tab" })
map.set("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "Close current tab" })

-- selection helpers
map.set("n", "<leader>ya", "goVGy", { desc = "Copy buffer content" })
map.set("n", "<leader>yd", "goVGd", { desc = "Delete buffer content" })
map.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down one line" })
map.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up one line" })
map.set("x", "<leader>p", '"_dP', { desc = "Replace selection with default register content" })
map.set("n", "<leader>P", "goVGP", { desc = "Replace buffer with default register content" })

-- disable arrow keys to make life harder
map.set({ "n", "v", "i" }, "<up>", "<nop>", { noremap = true })
map.set({ "n", "v", "i" }, "<down>", "<nop>", { noremap = true })
map.set({ "n", "v", "i" }, "<left>", "<nop>", { noremap = true })
map.set({ "n", "v", "i" }, "<right>", "<nop>", { noremap = true })
