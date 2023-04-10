--- Provides snippets for C++.

local ls = require("luasnip")
local query = require("vim.treesitter.query")
local snippet = ls.snippet
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local i = ls.insert_node
local d = ls.dynamic_node
local n = require("luasnip.extras").nonempty
local f = ls.function_node
local t = ls.text_node
local r = ls.restore_node
local c = ls.choice_node
local s = ls.snippet_node

local ts_utils = require("nvim-treesitter.ts_utils")

local cpp_classes = vim.treesitter.query.parse("cpp", [[
    [
        (struct_specifier name: [((type_identifier) @name) (template_type name: (type_identifier) @name)])
        (class_specifier name: [((type_identifier) @name) (template_type name: (type_identifier) @name)])
    ] @class
]])

--- Returns list of all C++ classes or structs in the language tree that contains a given line.
-- @param linenr Line number that will be used to get the language tree.
-- @return List of tuples (line begin, line end, class name). Lines use inclusive 1-indexing.
local function list_classes(linenr)
    local bufnr = vim.api.nvim_get_current_buf()

    local root = ts_utils.get_root_for_position(linenr - 1, 0)
    if not root then return {} end

    local result = {}

    for _, captures, _ in cpp_classes:iter_matches(root, bufnr) do
        local lbegin, _, lend, _ = ts_utils.get_vim_range({captures[2]:range()})
        local name = vim.treesitter.get_node_text(captures[1], bufnr)
        table.insert(result, {lbegin, lend, name})
    end

    return result
end


--- Gets name of the surrounding C++ class.
-- @param linenr Line number to use.
-- @return Name of the surrounding class or nil if none was found.
local function get_surrounding_class(linenr)
    local classes = list_classes(linenr)
    local min_range
    local min_name

    for _, class_info in pairs(classes) do
        local lbegin, lend, name = unpack(class_info)

        if lbegin <= linenr and lend >= linenr and (not min_range or lend - lbegin < min_range) then
            min_range = lend - lbegin
            min_name = name
        end
    end

    return min_name
end


return {
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

    -- Standard library types / containers
    ls.parser.parse_snippet("vec", "std::vector<${1:T}>"),
    ls.parser.parse_snippet("map", "std::unordered_map<${1:Key}, ${2:Value}>"),
    ls.parser.parse_snippet("imap", "std::map<${1:Key}, ${2:Value}>"),
    ls.parser.parse_snippet("str", "std::string"),
    ls.parser.parse_snippet("up", "std:unique_ptr<${1:T}>"),
    ls.parser.parse_snippet("sp", "std:shared_ptr<${1:T}>"),

    -- Attributes
    ls.parser.parse_snippet("nd", "[[nodiscard]]"),

    -- Special member declarations
    snippet("consd", {d(1, function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
        assert(cname, "Could not get surrounding class!")
        return s(nil, {t(cname), t("("), i(1), t(");")})
    end)}),
    snippet("cconsd", {f(function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
        assert(cname, "Could not get surrounding class!")
        return cname .. "(" .. cname .. " const& other);"
    end)}),
    snippet("mconsd", {f(function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
        assert(cname, "Could not get surrounding class!")
        return cname .. "(" .. cname .. "&& other) noexcept;"
    end)}),
    snippet("cassd", {f(function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
        assert(cname, "Could not get surrounding class!")
        return cname .. "& operator=(" .. cname .. " const& other);"
    end)}),
    snippet("massd", {f(function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
        assert(cname, "Could not get surrounding class!")
        return cname .. "& operator=(" .. cname .. "&& other) noexcept;"
    end)}),
    snippet("desd", {f(function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))
        assert(cname, "Could not get surrounding class!")
        return "~" .. cname .. "();"
    end)}),

    -- Special member definitions
    snippet("consi", {d(1, function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

        if cname then
            return s(nil, {t(cname .. "("), i(1), t(")"), n(2, " : "), i(2), t({" {", "\t"}), i(3), t({"", "}"})})
        else
            return s(nil, {i(1, "Class"), t("::"), rep(1), t("("), i(2), t(")"), n(3, " : "), i(3), t({" {", "\t"}), i(4), t({"", "}"})})
        end
    end)}),
    snippet("cconsi", {d(1, function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

        if cname then
            return s(nil, {t({cname .. "(" .. cname .. " const& other) {", "\t"}), i(1), t({"", "}"})})
        else
            return s(nil, {i(1, "Class"), t("::"), l(l._1:match("([^<]*)"), 1), t("("), l(l._1:match("([^<]*)"),1), t({" const& other) {", "\t"}), i(2), t({"", "}"})})
        end
    end)}),
    snippet("mconsi", {d(1, function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

        if cname then
            return s(nil, {t({cname .. "(" .. cname .. "&& other) noexcept {", "\t"}), i(1), t({"", "}"})})
        else
            return s(nil, {i(1, "Class"), t("::"), l(l._1:match("([^<]*)"), 1), t("("), l(l._1:match("([^<]*)"), 1), t({"&& other) noexcept {", "\t"}), i(2), t({"", "}"})})
        end
    end)}),
    snippet("cassi", {d(1, function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

        if cname then
            return s(nil, {t({cname .. "& operator=(" .. cname .. " const& other) {", "\t"}), i(1), t({"", "\treturn *this;", "}"})})
        else
            return s(nil, {i(1, "Class"), t("& "), rep(1), t("::operator=("), l(l._1:match("([^<*])"), 1), t({" const& other) {", "\t"}), i(2), t({"", "\treturn *this;", "}"})})
        end
    end)}),
    snippet("massi", {d(1, function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

        if cname then
            return s(nil, {t({cname .. "& operator=(" .. cname .. "&& other) noexcept {", "\t"}), i(1), t({"", "\treturn *this;", "}"})})
        else
            return s(nil, {i(1, "Class"), t("& "), rep(1), t("::operator=("), l(l._1:match("([^<]*)"), 1), t({"&& other) noexcept {", "\t"}), i(2), t({"", "\treturn *this;", "}"})})
        end
    end)}),
    snippet("desi", {d(1, function(_, snip)
        local cname = get_surrounding_class(tonumber(snip.env.TM_LINE_NUMBER))

        if cname then
            return s(nil, {t({"~" .. cname .. "() {", "\t"}), i(1), t({"", "}"})})
        else
            return s(nil, {i(1, "Class"), t("::~"), l(l._1:match("([^<]*)"), 1), t({"() {", "\t"}), i(2), t({"", "}"})})
        end
    end)}),

    -- Other
    ls.parser.parse_snippet("ip", "${1:range}.begin(), $1.end()"),
    ls.parser.parse_snippet("print", "std::cout << $1 << '\\n';"),
    snippet("bind", {c(1, {
        s(nil, {t("auto const& ["), r(1, "bindings"), t("] = "), r(2, "value"), t(";")}),
        s(nil, {t("auto&& ["), r(1, "bindings"), t("] = "), r(2, "value"), t(";")}),
    })}, {stored = {bindings = i(1, "bindings"), value = i(2, "value")}}),
    snippet("main", {
        t("int main("),
        c(1, {
            t(""),
            t("int const argc, char const* const* const argv")
        }),
        t{") {", "\t"}, i(0), t{"", "}"}
    }),
    snippet("inc", {
        t("#include "), c(1, {
            s(nil, {t("<"), r(1, "header"), t(">")}),
            s(nil, {t("\""), r(1, "header"), t("\"")}),
        }),
    }, {stored = {header = i(1, "header")}}),
    ls.parser.parse_snippet("cinit", "auto const $1 = [&] {\n\t$0\n}();")
}
