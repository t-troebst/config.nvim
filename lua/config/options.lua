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
vo.colorcolumn = { 101 }

vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "textwidth",
    group = vim.api.nvim_create_augroup("ColorColumnUpdate", {}),
    callback = function()
        if vim.v.option_type == "global" then
            vim.opt.colorcolumn = { vim.v.option_new }
        else
            vim.opt_local.colorcolumn = { vim.v.option_new }
        end
    end,
})

vo.shiftwidth = 4
vo.tabstop = 4
vo.expandtab = true

vim.g.tex_flavor = "latex"
vim.g.python3_host_prog = "/usr/bin/python3"

vim.g.mapleader = ","
vim.g.maplocalleader = ";"

vim.diagnostic.config {
    virtual_text = true,
    virtual_lines = false,
}
