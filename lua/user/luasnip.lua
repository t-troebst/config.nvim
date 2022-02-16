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
local d = ls.dynamic_node
local t = ls.text_node
local s = ls.snippet_node

-- Needed for fancy snippets
local ts_utils_ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
local parsers_ok, parsers = pcall(require, "nvim-treesitter.parsers")
if not (ts_utils_ok and parsers_ok) then
    return
end

local query = pcall(require, "vim.treesitter.query")

--- Obtains list of parameter names for the next function via treesitter.
-- @param linenr Line number at which we start searching.
-- @return List of parameters, in the order that they appear in the function.
local function next_fun_parms(linenr)
    local bufnr = vim.api.nvim_get_current_buf()

    local lang = parsers.get_buf_lang(bufnr)
    if not parsers.has_parser(lang) then return {} end

    local root_tree = parsers.get_parser(bufnr)
    if not root_tree then return {} end

    local root = ts_utils.get_root_for_position(linenr - 1, 0, root_tree)
    if not root then return {} end

    local q = vim.treesitter.parse_query("lua",
        "(function_declaration parameters: (parameters) @parms)")
    local parms = {}

    local _, captures, _ = q:iter_matches(root, bufnr, linenr, linenr + 100)()
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
        ls.parser.parse_snippet("main", "int main() {\n\t$0\n}"),
        ls.parser.parse_snippet("for", "for (std::size_t ${1:i} = ${2:0}; $1 < ${3:n}; ++$1) {\n\t$0\n}"),
        ls.parser.parse_snippet("print", "std::cout << $1 << '\\n';")
    },

    markdown = {
        ls.parser.parse_snippet("code", "```${1}\n$0\n```")
    },

    latex = {
        ls.parser.parse_snippet("env", "\\begin{$1}\n\t$0\n\\end{$1}")
    }
}

