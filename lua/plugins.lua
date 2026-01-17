return {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lua/plenary.nvim" },

    { "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        config = function ()
            vim.cmd.colorscheme("rose-pine")
        end,
    },

    { "folke/which-key.nvim" },
    { "folke/snacks.nvim",
        lazy = false,
        opts = {
            indent = { enabled = true },
            input = { enabled = true },
            notifier = { enabled = true },
        },
    },
    { "cbochs/grapple.nvim" },
    { "phaazon/hop.nvim", config = true, cmd = { "HopChar1" } },
    { "numToStr/Comment.nvim", config = true },
    { "lewis6991/gitsigns.nvim", config = true },
    { "tpope/vim-fugitive" },
    { "ibhagwan/fzf-lua" },
    { "nvim-tree/nvim-tree.lua",
        config = {
            view = {
                side = "right",
            },
        },
    },
    { "nvim-lualine/lualine.nvim", config = true },
    { "akinsho/bufferline.nvim", config = true },

    { "williamboman/mason.nvim",
        config = true,
    },
    { "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    { "stevearc/conform.nvim",
        config = {
            formatters = {
                lua = { "stylua" },
            },
        },
        format_on_save = {
            async = true,
            lsp_format = "fallback",
        },
    },

    { "mfussenegger/nvim-lint",
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
    }
}
