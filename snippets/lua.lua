--- Provides snippets for Lua.

local ts_utils = require("nvim-treesitter.ts_utils")

local function_q = vim.treesitter.query.parse(
    "lua",
    [[
    [
        (function_declaration parameters: (parameters) @parms)
        (function_definition parameters: (parameters) @parms)
    ] @fun
]]
)
-- This only matches returns that actually return something, so early return can still be used for
-- control flow!
local return_q = vim.treesitter.query.parse("lua", "(return_statement (expression_list)) @ret")

--- Obtains list of parameter names for the next lua function and whether it returns something.
-- @param linenr Line number at which we start searching.
-- @return parms, ret where parms is a list of parameters, in the order that they appear in the
--         function and ret is truthy if the function ever returns something.
local function next_fun_parms(linenr)
    local bufnr = vim.api.nvim_get_current_buf()

    -- TODO: Doesn't work if we land inside of a comment block because that's a different
    -- "language".
    local root = ts_utils.get_root_for_position(linenr - 1, 0)
    if not root then
        return
    end

    for _, captures, _ in function_q:iter_matches(root, bufnr) do
        local sline = captures[1]:range()

        if sline >= linenr - 1 then
            local parms = {}
            for parm, node_type in captures[1]:iter_children() do
                -- Parameters are given via "name" nodes, other nodes might be comments etc.
                if node_type == "name" then
                    table.insert(parms, vim.treesitter.get_node_text(parm, bufnr))
                end
            end

            local returns = return_q:iter_matches(captures[2], bufnr)()
            return parms, returns
        end
    end
end

return {
    parse("for", "for ${1:i} = ${2:1}, ${3:n} do\n\t$0\nend"),
    parse("fun", "local function ${1:name}($2)\n\t$0\nend"),
    parse("while", "while ${1:cond} do\n\t$0\nend"),
    parse("mfun", "function M.${1:name}($2)\n\t$0\nend"),
    parse("pairs", "for ${1:key}, ${2:value} in pairs($3) do\n\t$0\nend"),
    parse("ipairs", "for ${1:i}, ${2:value} in ipairs($3) do\n\t$0\nend"),
    parse("if", "if ${1:cond} then\n\t$0\nend"),
    parse("ifn", "if not ${1:cond} then\n\t$0\nend"),
    s(
        "req",
        fmt('local {} = require("{}")', {
            l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
            i(1, "module"),
        })
    ),
    s(
        "preq",
        fmt('local {1}_ok, {1} = pcall(require, "{}")\nif not {1}_ok then return end', {
            l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
            i(1, "module"),
        })
    ),
    s("doc", {
        t("--- "),
        i(1, "Function description."),
        d(2, function(_, snip)
            local parms, ret = next_fun_parms(tonumber(snip.env.TM_LINE_NUMBER))
            assert(parms, "Did not find a function!")

            local parm_nodes = {}
            for j, parm in ipairs(parms) do
                table.insert(parm_nodes, t { "", "-- @param " .. parm .. " " })
                table.insert(parm_nodes, i(j, "Parameter description."))
            end

            if ret then
                table.insert(parm_nodes, t { "", "-- @return " })
                table.insert(parm_nodes, i(#parms + 1, "Return description."))
            end

            return s(1, parm_nodes)
        end),
    }),
}
