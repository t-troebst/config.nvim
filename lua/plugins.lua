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
}
