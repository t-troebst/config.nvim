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
local function_q = vim.treesitter.parse_query("lua",[[
    [
        (function_declaration parameters: (parameters) @parms)
        (function_definition parameters: (parameters) @parms)
    ] @fun
]])
-- This only matches returns that actually return something, so early return can still be used for
-- control flow!
local return_q = vim.treesitter.parse_query("lua", "(return_statement (expression_list)) @ret")

--- Obtains list of parameter names for the next lua function and whether it returns something.
-- @param linenr Line number at which we start searching.
-- @return parms, ret where parms is a list of parameters, in the order that they appear in the
--         function and ret is truthy if the function ever returns something.
local function next_fun_parms(linenr)
    local bufnr = vim.api.nvim_get_current_buf()

    -- TODO: Why is linenr + 1 necessary here? Without this, the code doesn't work if we're in the
    -- first non-empty line of the document. But treesitter does 0-indexed lines??
    local root = ts_utils.get_root_for_position(linenr + 1, 0)
    if not root then return end

    -- TODO: For some strange reason we cannot find functions that are entirely on the last line of
    -- the file, no matter what we input for the end of the range. :/
    local _, captures, _ = function_q:iter_matches(root, bufnr, linenr - 1, root:end_())()
    if not captures then return end

    local parms = {}
    for parm, node_type in captures[1]:iter_children() do
        -- Parameters are given via "name" nodes, other nodes might be comments etc.
        if node_type == "name" then
            table.insert(parms, query.get_node_text(parm, bufnr))
        end
    end

    local returns = return_q:iter_matches(captures[2], bufnr)()
    return parms, returns
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
        t"--- ",
        i(1, "Function description."),
        d(2, function(_, snip)
            local parms, ret = next_fun_parms(tonumber(snip.env.TM_LINE_NUMBER))
            assert(parms, "Did not find a function!")

            local parm_nodes = {}
            for j, parm in ipairs(parms) do
                table.insert(parm_nodes, t{"", "-- @param " .. parm .. " "})
                table.insert(parm_nodes, i(j, "Parameter description."))
            end

            if ret then
                table.insert(parm_nodes, t{"", "-- @return "})
                table.insert(parm_nodes, i(#parms + 1, "Return description."))
            end

            return s(1, parm_nodes)
        end),
    })
}
