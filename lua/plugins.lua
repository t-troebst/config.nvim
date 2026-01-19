return {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lua/plenary.nvim" },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("rose-pine")
        end,
    },

    { "folke/which-key.nvim" },
    {
        "folke/snacks.nvim",
        lazy = false,
        opts = {
            indent = { enabled = true, animate = { enabled = false } },
            input = { enabled = true },
            notifier = { enabled = true },
        },
    },
    { "cbochs/grapple.nvim" },
    { "phaazon/hop.nvim", opts = {}, cmd = { "HopChar1" } },
    { "christoomey/vim-tmux-navigator", lazy = false },
    { "numToStr/Comment.nvim", opts = {} },
    { "lewis6991/gitsigns.nvim", opts = {} },
    { "tpope/vim-fugitive" },
    {
        "ibhagwan/fzf-lua",
        opts = {
            keymap = {
                fzf = {
                    ["ctrl-d"] = "down",
                    ["ctrl-u"] = "up",
                },
            },
            ui_select = true,
        },
    },
    {
        "nvim-tree/nvim-tree.lua",
        config = {
            view = {
                side = "right",
            },
        },
    },
    { "nvim-lualine/lualine.nvim", opts = {} },
    { "akinsho/bufferline.nvim", opts = {} },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            local ensure_installed = {
                "c",
                "cpp",
                "lua",
                "python",
                "markdown",
                "vim",
                "vimdoc",
                "query",
                "markdown_inline",
                "gitcommit",
            }

            require("nvim-treesitter").install(ensure_installed)

            vim.api.nvim_create_autocmd("FileType", {
                desc = "User: enable treesitter highlighting",
                callback = function(ctx)
                    -- highlights
                    local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

                    -- indent
                    local noIndent = {}
                    if hasStarted and not vim.list_contains(noIndent, ctx.match) then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    {
        "saghen/blink.cmp",
        version = "1.*",
        opts = {
            signature = { enabled = true },
            completion = {
                list = {
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },
                documentation = { auto_show = true },
                trigger = {
                    show_on_keyword = false,
                },
                menu = {
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind" },
                        },
                    },
                },
            },
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        },
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                python = { "ruff" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },

    {
        "t-troebst/perfanno.nvim",
        config = function()
            local perfanno = require("perfanno")
            local util = require("perfanno.util")
            local palette = require("rose-pine.palette")

            perfanno.setup {
                line_highlights = util.make_bg_highlights(nil, palette.love, 10),
                vt_highlight = util.make_fg_highlight(palette.love),
            }
        end,
        dev = true,
        cmd = {
            "PerfCacheDelete",
            "PerfCacheLoad",
            "PerfLoadCallGraph",
            "PerfLoadFlamegraph",
            "PerfLoadFlat",
            "PerfLuaProfileStart",
        },
    },
}
