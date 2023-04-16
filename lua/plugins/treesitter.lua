return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    version = false,
    build = ":TSUpdate",
    opts = {
        ensure_installed = "all",
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
        },
        indent = { enable = true },
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["af"] = { query = "@function.outer", desc = "a function" },
                    ["if"] = { query = "@function.inner", desc = "inner function" },
                    ["ac"] = { query = "@comment.outer", desc = "a comment" },
                    ["ic"] = { query = "@comment.inner", desc = "inner comment" },
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<LEADER>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<LEADER>A"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                goto_next_start = {
                    ["]f"] = "@function.outer",
                },
                goto_next_end = {
                    ["]F"] = "@function.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                },
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
