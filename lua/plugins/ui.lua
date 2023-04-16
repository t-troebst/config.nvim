return {
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            input = {
                relative = "editor",
            },
        },
    },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        opts = {
            render = "minimal",
            top_down = false,
        },
        config = function(_, opts)
            local notify = require("notify")
            notify.setup(opts)
            vim.notify = notify
        end
    },
}
