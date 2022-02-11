local status_ok, perfanno = pcall(require, "perfanno")
if not status_ok then
    return
end

local util = require("perfanno.util")

local bgcolor = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg", "gui")

perfanno.setup {
    line_highlights = util.make_bg_highlights(bgcolor, "#CC3300", 10),
    vt_highlight = util.make_fg_highlight("#CC3300"),
}
