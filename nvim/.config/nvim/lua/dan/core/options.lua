local opt = vim.opt

-- shows absolute line number
opt.number = true

-- tab and indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- disable line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- assumes you want case-sensitive if there is mixed case

opt.termguicolors = true
-- highlight the current cursor line
opt.cursorline = true

-- allow backspace on indent, end of line or insert mode start position
opt.backspace = "indent,eol,start"

-- use system clipboard as default register
opt.clipboard:append("unnamedplus")

opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- turn on spell check
opt.spelllang = "en_us"
opt.spell = true

-- restore session config
vim.o.sessionoptions =
  "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
