-- shows absolute line number
vim.o.number = true
-- useful for navigating through lines using motions
vim.o.relativenumber = true

-- tab and indentation
vim.o.tabstop = 2 -- prettier default
vim.o.shiftwidth = 2 -- 2 spaces for indent width
vim.o.expandtab = true -- expand tab to spaces
vim.o.autoindent = true

-- disable line wrapping
vim.o.wrap = false

-- search settings
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.termguicolors = true
-- highlight the current cursor line
vim.o.cursorline = true

-- allow backspace on indent, end of line or insert mode start position
vim.o.backspace = "indent,eol,start"

-- use system clipboard as default register
vim.o.clipboard = "unnamedplus"

-- save undo history
vim.o.undofile = true

vim.o.splitright = true -- split vertical window to the right
vim.o.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
vim.o.swapfile = false

vim.o.spelllang = "en_us"

-- fold configuration
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- restore session config
vim.o.sessionoptions =
  "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- time required to trigger CursorHold
vim.o.updatetime = 1000

-- disable optional language provider health checks
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
