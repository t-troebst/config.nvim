-- colorscheme

-- Nordfox

-- local status_ok, nightfox = pcall(require, "nightfox")
-- if not status_ok then
--     return
-- end
--
-- nightfox.load("nordfox")

-- Tokyo night

local status_ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
if not status_ok then
    return
end

