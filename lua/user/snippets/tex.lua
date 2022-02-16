--- Provides snippets for LaTeX.

local ls = require("luasnip")

return {
    ls.parser.parse_snippet("env", "\\begin{$1}\n\t$0\n\\end{$1}")
}
