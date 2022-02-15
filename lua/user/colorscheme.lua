-- Colorscheme

vim.cmd[[colorscheme no-clown-fiesta]]

-- Custom highlights for DAP

vim.highlight.create("Breakpoint", {guifg = "#AC4142"}, false)
vim.highlight.create("Continue", {guifg = "#90A959"}, false)
