local cmp_status_ok, cmp = pcall(require, "cmp")
local snip_status_ok, luasnip = pcall(require, "luasnip")
local lspkind_ok, lspkind = pcall(require, "lspkind")

if not (cmp_status_ok and snip_status_ok and lspkind_ok) then
    return
end

local timer = vim.loop.new_timer()

--- Starts autocompletion after the given delay.
-- @param delay Delay in milliseconds.
function DebounceCMP(delay)
    timer:stop()
    timer:start(delay, 0, vim.schedule_wrap(function()
        cmp.complete({ reason = cmp.ContextReason.Auto })
    end))
end

cmp.setup {
    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
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
        format = lspkind.cmp_format {
            mode = "symbol_text",

            menu = {
                buffer = "[buf]",
                path = "[path]",
                luasnip = "[snip]",
                nvim_lsp = "[lsp]",
                nvim_lua = "[api]",
            }
        }
    },

    documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },

    experimental = {
        ghost_text = true,
        native_menu = false,
    },

    completion = {
        autocomplete = false  -- We use the debouncing method.
    }
}

vim.cmd([[
    augroup CmpDebounceAuGroup
        au!
        au TextChangedI * lua DebounceCMP(1000)
    augroup end
]])
