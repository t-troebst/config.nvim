--- Provides snippets for LaTeX.

local ls = require("luasnip")
local snippet = ls.snippet
local fmt = require("luasnip.extras.fmt").fmta
local l = require("luasnip.extras").lambda
local i = ls.insert_node
local c = ls.choice_node
local r = ls.restore_node
local d = ls.dynamic_node
local n = require("luasnip.extras").nonempty
local t = ls.text_node
local s = ls.snippet_node

local item_rec
item_rec = function(_, _, _, depth)
    return s(nil, c(1, {
        s(nil, {t("\\item "), r(1, "item" .. tostring(depth), i(1, "\\TODO"))}),
        s(nil, {t{"\\item "}, r(1, "item" .. tostring(depth)), t{"", "\t"}, d(2, item_rec, {}, {user_args = {depth + 1}})})
    }))
end

return {
    ls.parser.parse_snippet("pack", "\\usepackage{$1}"),
    ls.parser.parse_snippet("env", "\\begin{$1}$2\n\t${0:\\TODO}\n\\end{$1}"),

    ls.parser.parse_snippet("ct", "\\cite{$1}"),
    ls.parser.parse_snippet("r", "\\ref{$1}"),
    ls.parser.parse_snippet("l", "\\label{$1}"),
    ls.parser.parse_snippet("er", "\\eqref{$1}"),
    ls.parser.parse_snippet("bf", "\\textbf{$1}"),
    ls.parser.parse_snippet("em", "\\emph{$1}"),


    -- Common environments
    ls.parser.parse_snippet("eq", "\\begin{equation}\\label{eq:$1}\n\t$0\n\\end{equation}"),
    ls.parser.parse_snippet("eq*", "\\begin{equation*}\n\t$0\n\\end{equation*}"),
    ls.parser.parse_snippet("align", "\\begin{align}\\label{$1}\n\t$0\n\\end{align}"),
    ls.parser.parse_snippet("align*", "\\begin{align*}\n\t$0\n\\end{align*}"),
    ls.parser.parse_snippet("thm", "\\begin{theorem}\\label{thm:$1}\n\t${0:\\TODO}\n\\end{theorem}"),
    ls.parser.parse_snippet("lem", "\\begin{lemma}\\label{lem:$1}\n\t${0:\\TODO}\n\\end{lemma}"),
    ls.parser.parse_snippet("cor", "\\begin{corollary}\\label{cor:$1}\n\t${0:\\TODO}\n\\end{corollary}"),
    ls.parser.parse_snippet("def", "\\begin{definition}\\label{def:$1}\n\t${0:\\TODO}\n\\end{definition}"),
    ls.parser.parse_snippet("proof", "\\begin{proof}\n\t${0:\\TODO}\n\\end{proof}"),
    ls.parser.parse_snippet("frame", "\\begin{frame}{${1:\\TODO: Title}}\n\t${0:\\TODO}\n\\end{frame}"),
    snippet("enum", {
        t{"\\begin{enumerate}", "\t\\item "}, i(1, "\\TODO"), t{"", "\t"}, d(2, item_rec, {}, {user_args = {1}}), t{"", "\\end{enumerate}"}
    }),
    snippet("item", {
        t{"\\begin{itemize}", "\t\\item "}, i(1, "\\TODO"), t{"", "\t"}, d(2, item_rec, {}, {user_args = {1}}), t{"", "\\end{itemize}"}
    }),

    -- Figures and tables
    ls.parser.parse_snippet("fig", "\\begin{figure}[h]\n\t\\centering\n\t\\begin{tikzpicture}\n\t\t$0\n\t\\end{tikzpicture}\n\t\\caption{${1:\\TODO}}\n\t\\label{fig:$2}\n\\end{figure}"),
    snippet("node", fmt("\\node[<>]<><><> at (<>) {<>};", {i(1), n(2, " ("), i(2), n(2, ")"), i(3), i(4)})),
    snippet("foreach", {
        t"\\foreach ", c(1, {
            r(1, "item", i(1, "\\item")),
            s(nil, {r(1, "item"), t" [\\count=", i(2, "\\i"), t"]"})
        }), t" \\in {", i(2), t{"}", "\t"}, i(0), t{"", "}"}
    }),

    -- Math mode
    ls.parser.parse_snippet("fr", "\\frac{$1}{$2}"),
    snippet("lr", c(1, {
        s(nil, {t"\\left(", i(1), t"\\right)"}),
        s(nil, {t"\\left\\{", i(1), t"\\right\\}"}),
        s(nil, {t"\\left[", i(1), t"\\right]"})
    })),
    ls.parser.parse_snippet("s", "\\sum_{$1}^{$2}{$3}")
}
