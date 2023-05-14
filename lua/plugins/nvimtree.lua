local function setup()
    local nvim_tree = require("nvim-tree")
    local config = require("nvim-tree.config")
    local tree_cb = config.nvim_tree_callback

    nvim_tree.setup {
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = false,
        update_cwd = true,
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        diagnostics = {
            enable = true,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
        update_focused_file = {
            enable = true,
            update_cwd = true,
            ignore_list = {},
        },
        git = {
            enable = true,
            ignore = true,
            timeout = 500,
        },
        view = {
            width = 30,
            hide_root_folder = false,
            side = "right",
            number = false,
            relativenumber = false,
        },
        renderer = {
            icons = {
                glyphs = {
                    default = "",
                    symlink = "",
                    git = {
                        unstaged = "",
                        staged = "S",
                        unmerged = "",
                        renamed = "➜",
                        deleted = "",
                        untracked = "U",
                        ignored = "◌",
                    },
                    folder = {
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                    },
                },
            },
        },
    }
end

return {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    config = setup
}
