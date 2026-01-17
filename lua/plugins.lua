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
            indent = { enabled = true },
            input = { enabled = true },
            notifier = { enabled = true },
        },
    },
    { "cbochs/grapple.nvim" },
    { "phaazon/hop.nvim", opts = {}, cmd = { "HopChar1" } },
    { "numToStr/Comment.nvim", opts = {} },
    { "lewis6991/gitsigns.nvim", opts = {} },
    { "tpope/vim-fugitive" },
    {
        "ibhagwan/fzf-lua",
        lazy = false,
        opts = {
            keymap = {
                fzf = {
                    ["ctrl-d"] = "down",
                    ["ctrl-u"] = "up",
                },
            },
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
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
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
}
