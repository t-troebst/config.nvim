-- Colorscheme

local status_ok, onedark = pcall(require, "onedark")
if not status_ok then
    return
end

onedark.setup{}

-- Custom highlights for DAP

vim.highlight.create("Breakpoint", {guifg = "#eb4034"}, false)
vim.highlight.create("Continue", {guifg = "#34eb61"}, false)
