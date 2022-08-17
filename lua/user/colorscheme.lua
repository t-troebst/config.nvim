-- Colorscheme

vim.cmd [[colorscheme rose-pine]]

-- Custom highlights for DAP

vim.highlight.create("Breakpoint", { guifg = "#eb6f92" }, false)
vim.highlight.create("Continue", { guifg = "#31748f" }, false)
