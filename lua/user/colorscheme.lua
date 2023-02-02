-- Colorscheme

vim.cmd [[colorscheme rose-pine]]

-- Custom highlights for DAP

vim.api.nvim_set_hl(0, "Breakpoint", { fg = "#eb6f92" })
vim.api.nvim_set_hl(0, "Continue", { fg = "#31748f" })
