vim.o.swapfile = false

-- set a ruler at column 100
vim.opt.colorcolumn = "100"
-- save undo history
vim.o.undofile = true

-- smart line wrap
vim.o.linebreak = true
vim.o.breakindent = true

-- shows absolute and relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- highlight the current cursor line
vim.o.cursorline = true

-- tab and indentation
vim.o.shiftwidth = 2 -- << and >> use 2 spaces
vim.o.expandtab = true -- tab turns into spaces
vim.o.tabstop = 2 -- tab equals 2 spaces

-- show whitespace
vim.o.list = true
vim.opt.listchars = { tab = "  ", trail = "·" }

vim.opt.diffopt:append({
	"algorithm:histogram",
	"indent-heuristic",
	"linematch:60",
	"followwrap",
	"context:99",
})
vim.opt.fillchars:append({ diff = " " })

-- split window behaviour
vim.o.splitright = true
vim.o.splitbelow = true

-- search settings
vim.o.ignorecase = true
vim.o.smartcase = true

-- use system clipboard as default register
vim.o.clipboard = "unnamedplus"

-- fold configuration
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- restore session config
vim.o.sessionoptions = "blank,buffers,curdir,folds,tabpages,winsize,winpos,terminal,localoptions"

-- time required to trigger CursorHold
vim.o.updatetime = 1000
