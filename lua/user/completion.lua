local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

--   פּ ﯟ   some other good icons
local kind_icons = {
    Text = "",
    Method = "m",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

cmp.setup {
    mapping = {
        ["<C-j>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-k>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        },
        ["<C-space>"] = cmp.mapping.complete()
    },

    sources = {
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "path" },
        { name = "luasnip" },
        { name = "buffer", keyword_length = 5 },
    },

    snippet = {
        -- Use LuaSnip to expand VS Code style snippets returned by LSP
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            vim_item.menu = ({
                nvim_lua = "[api]",
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                path = "[Path]",
                buffer = "[Buf]",
            })[entry.source.name]
            return vim_item
        end,
    },

    documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },

    experimental = {
        ghost_text = true,
        native_menu = false,
    }
}
