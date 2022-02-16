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
local fmta = require("luasnip.extras.fmt").fmta
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local i = ls.insert_node
local d = ls.dynamic_node
local t = ls.text_node
local r = ls.restore_node
local c = ls.choice_node
local s = ls.snippet_node

-- Needed for fancy snippets
local ts_utils_ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
if not ts_utils_ok then
    return
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

ls.snippets = {
    all = {  -- all filetypes
        -- TODO
    },

    lua = {
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
    },

    python = {
        ls.parser.parse_snippet("main", "def main():\n\t$0\n\nif __name__ == \"__main__\":\n\tmain()"),
        ls.parser.parse_snippet("for", "for ${1:i} in range(${2:0}, ${3:n}):\n\t$0")
    },

    cpp = {
        ls.parser.parse_snippet("main", "int main(${1|,int const argc\\, char const* const* const argv}) {\n\t$0\n}"),
        snippet("inc", {
            t("#include "), c(1, {
                s(nil, {t("<"), r(1, "header"), t(">")}),
                s(nil, {t("\""), r(1, "header"), t("\"")}),
            }),
        }, {stored = {header = i(1, "header")}}),
        snippet("for", {
            t("for ("),
            c(1, {
                s(nil, {t("std::size_t "), i(1, "i"), t(" = "), i(2, "0"), t("; "), rep(1), t(" < "), i(3, "n"), t("; "), rep(1)}),
                s(nil, {t("const auto& "), r(1, "elem"), t(" : "), r(2, "range")}),
                s(nil, {t("auto&& "), r(1, "elem"), t(" : "), r(2, "range")})
            }),
            t({") {", "\t"}), i(0), t({"", "}"})
        }, {stored = {elem = i(1, "elem"), range = i(2, "range")}}),
        ls.parser.parse_snippet("while", "while (${1:cond}) {\n\t$0\n}"),
        ls.parser.parse_snippet("do", "do {\n\t$0\n} while (${1:cond});"),
        ls.parser.parse_snippet("print", "std::cout << $1 << '\\n';"),
        snippet("if", {
            t("if ("),
            c(1, {
                r(1, "cond"),
                s(nil, {i(1, "init"), t("; "), r(2, "cond")})
            }),
            t({") {", "\t"}), i(0), t({"", "}"})
        }, {stored = {cond = i(1, "cond")}}),
        snippet("ifc", {
            t("if constexpr ("),
            c(1, {
                r(1, "cond"),
                s(nil, {i(1, "init"), t("; "), r(2, "cond")})
            }),
            t({") {", "\t"}), i(0), t({"", "}"})
        }, {stored = {cond = i(1, "cond")}}),
        ls.parser.parse_snippet("e", "else {\n\t$0\n}"),
        ls.parser.parse_snippet("ei", "else if ($1) {\n\t$0\n}"),
        ls.parser.parse_snippet("eic", "else if constexpr ($1) {\n\t$0\n}"),
        ls.parser.parse_snippet("cinit", "auto const $1 = [&] {\n\t$0\n}();"),
        snippet("bind", {c(1, {
            s(nil, {t("auto const& ["), r(1, "bindings"), t("] = "), r(2, "value"), t(";")}),
            s(nil, {t("auto&& ["), r(1, "bindings"), t("] = "), r(2, "value"), t(";")}),
        })}, {stored = {bindings = i(1, "bindings"), value = i(2, "value")}})

    },

    markdown = {
        ls.parser.parse_snippet("code", "```${1}\n$0\n```")
    },

    latex = {
        ls.parser.parse_snippet("env", "\\begin{$1}\n\t$0\n\\end{$1}")
    }
}

