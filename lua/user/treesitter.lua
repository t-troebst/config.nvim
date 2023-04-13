local configs = require("nvim-treesitter.configs")

configs.setup {
    ensure_installed = "all",
    sync_install = false,
    ignore_install = { "" }, -- List of parsers to ignore installing
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "" }, -- list of language that will be disabled
        additional_vim_regex_highlighting = true,
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
    -- indent = { enable = true },
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
}
