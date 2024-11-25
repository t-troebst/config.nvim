return {
    "t-troebst/perfanno.nvim",
    config = function()
        local perfanno = require("perfanno")
        local util = require("perfanno.util")
        local palette = require("rose-pine.palette")

        perfanno.setup {
            line_highlights = util.make_bg_highlights(nil, palette.love, 10),
            vt_highlight = util.make_fg_highlight(palette.love),
        }
    end,
    cmd = {
        "PerfCacheDelete",
        "PerfCacheLoad",
        "PerfLoadCallGraph",
        "PerfLoadFlamegraph",
        "PerfLoadFlat",
        "PerfLuaProfileStart"
    }
}
