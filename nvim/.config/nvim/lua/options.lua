vim.o.termguicolors = true
vim.o.swapfile = false

-- set a ruler at column 100
vim.opt.colorcolumn = "100"
-- save undo history
vim.o.undofile = true

-- disable line wrapping
vim.o.wrap = false

-- shows absolute and relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- highlight the current cursor line
vim.o.cursorline = true

-- tab and indentation
vim.o.autoindent = true
vim.o.shiftwidth = 2 -- << and >> use 2 spaces
vim.o.expandtab = true -- tab turns into spaces
vim.o.tabstop = 2 -- tab equals 2 spaces

-- show whitespace
vim.o.list = true
vim.opt.listchars = { tab = "  ", trail = "·" }

vim.opt.fillchars = vim.opt.fillchars + "diff:╱"

-- split window behaviour
vim.o.splitright = true
vim.o.splitbelow = true

-- search settings
vim.o.ignorecase = true
vim.o.smartcase = true

-- makes backspace work more like it does in a typical text editor
vim.o.backspace = "indent,eol,start"

-- use system clipboard as default register
vim.o.clipboard = "unnamedplus"

-- fold configuration
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- restore session config
vim.o.sessionoptions = "blank,buffers,curdir,folds,tabpages,winsize,winpos,terminal,localoptions"

-- time required to trigger CursorHold
vim.o.updatetime = 1000
