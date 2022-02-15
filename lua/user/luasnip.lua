local snip_status_ok, ls = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

ls.config.set_config {
    -- Allows reentering old snippets
    history = true,

    -- Update snippets dynamically while typing
    updateevents = "TextChanged,TextChangedI",

    -- Delete snippets from history when appropriate
    delete_check_events = "InsertLeave",

    -- Don't need autosnippets for now
    enabled_autosnippets = false,

    -- Ask treesitter for filetype for sub-languages
    ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype
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
        ls.parser.parse_snippet("for", "for ${1:i} = ${2:0}, $3 do\n\t$0\nend"),
        ls.parser.parse_snippet("fun", "local function ${1:name}($2)\n\t$0\nend"),
        ls.parser.parse_snippet("mfun", "function M.${1:name}($2)\n\t$0\nend"),
        ls.parser.parse_snippet("pairs", "for ${2:key}, ${3:value} in pairs($1) do\n\t$0\nend"),
        ls.parser.parse_snippet("ipairs", "for ${2:i}, ${3:value} in pairs($1) do\n\t$0\nend"),
        ls.parser.parse_snippet("if", "if ${1:cond} then\n\t$0\nend"),
        ls.parser.parse_snippet("ifn", "if not ${1:cond} then\n\t$0\nend"),
        snippet("req",
            fmt("local {} = require(\"{}\")", {
                l(l._1:match("[^.]*$"), 1),
                i(1, "module")
            })
        ),
        snippet("preq",
            fmt("local {1}_ok, {1} = pcall(require, \"{}\")\nif not {1}_ok then\n\treturn\nend", {
                l(l._1:match("[^.]*$"), 1),
                i(1, "module")
            })
        )
    },

    python = {
        ls.parser.parse_snippet("main", "def main():\n\t$0\n\nif __name__ == \"__main__\":\n\tmain()"),
        ls.parser.parse_snippet("for", "for ${1:i} in range(${2:0}, ${3}):\n\t$0")
    },

    cpp = {
        ls.parser.parse_snippet("main", "int main() {\n\t$0\n}"),
        ls.parser.parse_snippet("for", "for (std::size_t ${1:i} = ${2:0}; $1 < $3; ++$1) {\n\t$0\n}"),
        ls.parser.parse_snippet("print", "std::cout << $1 << '\\n';")
    },

    markdown = {
        ls.parser.parse_snippet("code", "```${1}\n$0\n```")
    },

    latex = {
        ls.parser.parse_snippet("env", "\\begin{$1}\n\t$0\n\\end{$1}")
    }
}

