-- Colorscheme

local palette_ok, palette = pcall(require, "rose-pine.palette")
if not palette_ok then return end

vim.cmd [[colorscheme rose-pine]]

-- Custom highlights for DAP

vim.api.nvim_set_hl(0, "Breakpoint", { fg = "#eb6f92" })
vim.api.nvim_set_hl(0, "Continue", { fg = "#31748f" })

vim.api.nvim_set_hl(0, "@attribute", { fg = palette.muted })
