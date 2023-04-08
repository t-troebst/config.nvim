local status_ok, perfanno = pcall(require, "perfanno")
if not status_ok then
    return
end

local util = require("perfanno.util")

local palette_ok, palette = pcall(require, "rose-pine.palette")
if not palette_ok then return end

local bgcolor = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg", "gui")

perfanno.setup {
    line_highlights = util.make_bg_highlights(bgcolor, palette.love, 10),
    vt_highlight = util.make_fg_highlight(palette.love),
}
