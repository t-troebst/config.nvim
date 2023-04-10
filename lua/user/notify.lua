local notify = require("notify")

notify.setup {
    render = "minimal",
    top_down = false,
}

vim.notify = notify
