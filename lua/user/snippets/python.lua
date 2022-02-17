--- Provides snippets for Python

local ls = require("luasnip")

return {
    ls.parser.parse_snippet("main", "def main():\n\t${0:pass}\n\nif __name__ == \"__main__\":\n\tmain()"),
    ls.parser.parse_snippet("for", "for ${1:i} in range(${2:0}, ${3:n}):\n\t$0")
}
