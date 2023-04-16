return {
    "t-troebst/perfanno.nvim",
    config = function()
        local perfanno = require("perfanno")
        local util = require("perfanno.util")
        local palette = require("rose-pine.palette")

        local bgcolor = vim.fn.synIDattr(vim.fn.hlID("Normal"), "bg", "gui")

        perfanno.setup {
            line_highlights = util.make_bg_highlights(bgcolor, palette.love, 10),
            vt_highlight = util.make_fg_highlight(palette.love),
        }
    end,
    cmd = {
        "PerfCacheDelete",
        "PerfCacheLoad",
        "PerfLoadCallgraph",
        "PerfLoadFlamegraph",
        "PerfLoadFlat",
        "PerfLuaProfileStart"
    }
}
