--- Provides snippets for Markdown.

local ls = require("luasnip")

return {
    ls.parser.parse_snippet("code", "```${1}\n$0\n```"),
}
