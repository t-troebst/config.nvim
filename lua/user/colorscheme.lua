-- colorscheme

-- Custom highlights

vim.highlight.create("Breakpoint", {guifg = "#eb4034"}, false)
vim.highlight.create("Continue", {guifg = "#34eb61"}, false)

-- Nordfox

-- local status_ok, nightfox = pcall(require, "nightfox")
-- if not status_ok then
--     return
-- end
--
-- nightfox.load("nordfox")

-- Tokyo night

vim.g.tokyonight_lualine_bold = true

local status_ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
if not status_ok then
    return
end
