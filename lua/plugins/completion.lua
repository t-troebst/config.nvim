local function setup()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    local timer = vim.loop.new_timer()

    --- Starts autocompletion after the given delay.
    -- @param delay Delay in milliseconds.
    function DebounceCMP(delay)
        timer:stop()
        timer:start(
            delay,
            0,
            vim.schedule_wrap(function()
                cmp.complete { reason = cmp.ContextReason.Auto }
            end)
        )
    end

    local mappings = {
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
        ["<C-space>"] = cmp.mapping.complete(),
    }

    cmp.setup {
        mapping = mappings,

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
                },
            },
        },

        window = {
            documentation = {
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            },
        },

        experimental = {
            ghost_text = true,
            native_menu = false,
        },

        completion = {
            autocomplete = false, -- We use the debouncing method.
        },
    }

    cmp.setup.cmdline(":", {
        mapping = mappings,
        sources = cmp.config.sources {
            { name = "path" },
            { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
        },
    })

    local augroup = vim.api.nvim_create_augroup("CmpDebounce", { clear = true })
    vim.api.nvim_create_autocmd("TextChangedI", {
        group = augroup,
        pattern = "*",
        callback = function()
            DebounceCMP(500)
        end,
    })
end

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "onsails/lspkind-nvim",
    },
    event = "InsertEnter",
    config = setup
}
