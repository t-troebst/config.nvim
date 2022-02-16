-- options

local vo = vim.opt

vo.signcolumn = "yes"
vo.number = true
vo.relativenumber = true
vo.cursorline = true

vo.mouse = "a"
vo.clipboard = "unnamedplus"

vo.cmdheight = 2
vo.showmode = false

vo.wrap = true
vo.linebreak = true
vo.showbreak = "... "
vo.scrolloff = 8
vo.sidescrolloff = 8

vo.fileencoding = "utf-8"

vo.gdefault = true
vo.ignorecase = true
vo.smartcase = true

vo.smartindent = true

vo.splitbelow = true
vo.splitright = true

vo.textwidth = 100
vo.colorcolumn = {101}

vo.shiftwidth = 4
vo.tabstop = 4
vo.expandtab = true

vim.cmd([[hi! link NonText Normal]])
