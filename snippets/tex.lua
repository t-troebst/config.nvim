--- Provides snippets for LaTeX.

local item_rec
item_rec = function(_, _, _, depth)
    return s(
        nil,
        c(1, {
            s(nil, { t("\\item "), r(1, "item" .. tostring(depth), i(1, "\\TODO")) }),
            s(nil, {
                t { "\\item " },
                r(1, "item" .. tostring(depth)),
                t { "", "\t" },
                d(2, item_rec, {}, { user_args = { depth + 1 } }),
            }),
        })
    )
end

return {
    parse("pack", "\\usepackage{$1}"),
    parse("env", "\\begin{$1}$2\n\t${0:\\TODO}\n\\end{$1}"),

    parse("ct", "\\cite{$1}"),
    parse("r", "\\ref{$1}"),
    parse("l", "\\label{$1}"),
    parse("er", "\\eqref{$1}"),
    parse("bf", "\\textbf{$1}"),
    parse("em", "\\emph{$1}"),

    -- Common environments
    parse("eq", "\\begin{equation}\\label{eq:$1}\n\t$0\n\\end{equation}"),
    parse("eq*", "\\begin{equation*}\n\t$0\n\\end{equation*}"),
    parse("align", "\\begin{align}\\label{$1}\n\t$0\n\\end{align}"),
    parse("align*", "\\begin{align*}\n\t$0\n\\end{align*}"),
    parse("thm", "\\begin{theorem}\\label{thm:$1}\n\t${0:\\TODO}\n\\end{theorem}"),
    parse("lem", "\\begin{lemma}\\label{lem:$1}\n\t${0:\\TODO}\n\\end{lemma}"),
    parse("cor", "\\begin{corollary}\\label{cor:$1}\n\t${0:\\TODO}\n\\end{corollary}"),
    parse("def", "\\begin{definition}\\label{def:$1}\n\t${0:\\TODO}\n\\end{definition}"),
    parse("proof", "\\begin{proof}\n\t${0:\\TODO}\n\\end{proof}"),
    parse("frame", "\\begin{frame}{${1:\\TODO: Title}}\n\t${0:\\TODO}\n\\end{frame}"),
    s("enum", {
        t { "\\begin{enumerate}", "\t\\item " },
        i(1, "\\TODO"),
        t { "", "\t" },
        d(2, item_rec, {}, { user_args = { 1 } }),
        t { "", "\\end{enumerate}" },
    }),
    s("item", {
        t { "\\begin{itemize}", "\t\\item " },
        i(1, "\\TODO"),
        t { "", "\t" },
        d(2, item_rec, {}, { user_args = { 1 } }),
        t { "", "\\end{itemize}" },
    }),

    -- Figures and tables
    parse(
        "fig",
        "\\begin{figure}[h]\n\t\\centering\n\t\\begin{tikzpicture}\n\t\t$0\n\t\\end{tikzpicture}\n\t\\caption{${1:\\TODO}}\n\t\\label{fig:$2}\n\\end{figure}"
    ),
    s(
        "node",
        fmta("\\node[<>]<><><> at (<>) {<>};", { i(1), n(2, " ("), i(2), n(2, ")"), i(3), i(4) })
    ),
    s("foreach", {
        t("\\foreach "),
        c(1, {
            r(1, "item", i(1, "\\item")),
            sn(nil, { r(1, "item"), t(" [\\count="), i(2, "\\i"), t("]") }),
        }),
        t(" \\in {"),
        i(2),
        t { "}", "\t" },
        i(0),
        t { "", "}" },
    }),

    -- Math mode
    parse("fr", "\\frac{$1}{$2}"),
    s(
        "lr",
        c(1, {
            sn(nil, { t("\\left("), i(1), t("\\right)") }),
            sn(nil, { t("\\left\\{"), i(1), t("\\right\\}") }),
            sn(nil, { t("\\left["), i(1), t("\\right]") }),
        })
    ),
    parse("s", "\\sum_{$1}^{$2}{$3}"),
}
