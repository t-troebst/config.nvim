--- Provides snippets for Python

return {
    parse("main", 'def main():\n\t${0:pass}\n\nif __name__ == "__main__":\n\tmain()'),
    parse("for", "for ${1:i} in range(${2:0}, ${3:n}):\n\t$0"),
}
