local snip_status_ok, ls = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

-- Load VS Code style snippets (e.g. from friendly-snippets) lazily
require("luasnip/loaders/from_vscode").lazy_load()

ls.config.set_config {
    -- Allows reentering old snippets
    history = true,

    -- Update snippets dynamically while typing
    updateevents = "TextChanged,TextChangedI",

    -- Delete snippets from history when appropriate
    delete_check_events = "InsertLeave",

    -- Don't need autosnippets for now
    enabled_autosnippets = false,
}

-- Set up actual snippets

local snippet = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local l = require("luasnip.extras").lambda
local i = ls.insert_node

ls.snippets = {
    all = {  -- all filetypes
        -- TODO
    },

    lua = {
        ls.parser.parse_snippet("fun", "local function $1($2)\n\t$0\nend"),
        snippet("req",
            fmt("local {} = require(\"{}\")", {
                l(l._1:match("[^.]*$"), 1),
                i(1)
            })
        ),
        snippet("preq",
            fmt("local {1}_ok, {1} = pcall(require, \"{}\")\nif not {1}_ok then\n\treturn\nend", {
                l(l._1:match("[^.]*$"), 1),
                i(1)
            })
        )
    },

    python = {
        ls.parser.parse_snippet("main", "def main():\n\tpass\n\nif __name__ == \"__main__\":\n\tmain()")
    },

    cpp = {
        -- TODO
    },
}

