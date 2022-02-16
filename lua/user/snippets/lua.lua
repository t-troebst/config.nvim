--- Provides snippets for Lua.

local ls = require("luasnip")
local snippet = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local l = require("luasnip.extras").lambda
local i = ls.insert_node
local d = ls.dynamic_node
local t = ls.text_node
local s = ls.snippet_node

-- Needed for fancy snippets
local ts_utils_ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
if not ts_utils_ok then
    return {}
end

local query = require("vim.treesitter.query")
local next_fun_q = vim.treesitter.parse_query("lua", "(parameters) @parms")

--- Obtains list of parameter names for the next lua function via treesitter.
-- @param linenr Line number at which we start searching.
-- @return List of parameters, in the order that they appear in the function.
local function next_fun_parms(linenr)
    local bufnr = vim.api.nvim_get_current_buf()

    -- TODO: Why is linenr + 1 necessary here?
    local root = ts_utils.get_root_for_position(linenr + 1, 0)
    if not root then return {} end

    local parms = {}

    local endline = vim.api.nvim_buf_line_count(bufnr)
    local _, captures, _ = next_fun_q:iter_matches(root, bufnr, linenr - 1, endline - 1)()
    if not captures then return {} end

    for parm, node_type in captures[1]:iter_children() do
        if node_type == "name" then
            table.insert(parms, query.get_node_text(parm, bufnr))
        end
    end

    return parms
end

return {
    ls.parser.parse_snippet("for", "for ${1:i} = ${2:0}, ${3:n} do\n\t$0\nend"),
    ls.parser.parse_snippet("fun", "local function ${1:name}($2)\n\t$0\nend"),
    ls.parser.parse_snippet("mfun", "function M.${1:name}($2)\n\t$0\nend"),
    ls.parser.parse_snippet("pairs", "for ${2:key}, ${3:value} in pairs($1) do\n\t$0\nend"),
    ls.parser.parse_snippet("ipairs", "for ${2:i}, ${3:value} in pairs($1) do\n\t$0\nend"),
    ls.parser.parse_snippet("if", "if ${1:cond} then\n\t$0\nend"),
    ls.parser.parse_snippet("ifn", "if not ${1:cond} then\n\t$0\nend"),
    snippet("req",
        fmt("local {} = require(\"{}\")", {
            l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
            i(1, "module")
        })
    ),
    snippet("preq",
        fmt("local {1}_ok, {1} = pcall(require, \"{}\")\nif not {1}_ok then\n\treturn\nend", {
            l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
            i(1, "module")
        })
    ),
    snippet("doc", {
        t("--- "),
        i(1, "Function description."),
        d(2, function(_, snip)
            local parm_nodes = {}

            for j, parm in ipairs(next_fun_parms(tonumber(snip.env.TM_LINE_NUMBER))) do
                table.insert(parm_nodes, t({"", "-- @param " .. parm .. " "}))
                table.insert(parm_nodes, i(j, "Parameter description."))
            end

            return s(1, parm_nodes)
        end, {}),
        t({"", "-- @return "}),
        i(3, "Return description.")
    })
}
