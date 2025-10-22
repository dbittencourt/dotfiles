vim.g.mapleader = " "
vim.g.maplocalleader = " "

local set = vim.keymap.set

set("n", "<leader>nh", "<cmd>nohl<cr>", { desc = "Clear search highlights" })
set("n", "<C-d>", "<C-d>zz", { desc = "Center screen after going down one page" })
set("n", "<C-u>", "<C-u>zz", { desc = "Center screen after going up one page" })

-- split management
set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
set("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close current split" })
set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
set("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })

-- tab management
set("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "Open new tab" })
set("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "Close current tab" })
for i = 1, 9 do
	set("n", "<leader>" .. i, "<cmd>tabnext " .. i .. "<cr>", { desc = "Go to tab " .. i })
end

-- selection helpers
set("n", "<leader>ya", "goVGy", { desc = "Copy buffer content" })
set("n", "<leader>yd", "goVGd", { desc = "Delete buffer content" })
set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down one line" })
set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up one line" })
set("x", "<leader>p", '"_dP', { desc = "Replace selection with default register content" })
set("n", "<leader>P", "goVGP", { desc = "Replace buffer with default register content" })

-- programming
set("n", "<leader>b", "<cmd>make<cr>", { desc = "Build project" })
set("n", "<leader>D", vim.diagnostic.setqflist, { desc = "Send diagnostics to quickfix" })
set("n", "<leader>q", function()
	local qf_open = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "buftype") == "quickfix" then
			qf_open = true
			break
		end
	end

	if qf_open then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end, { desc = "Toggle quickfix window" })
