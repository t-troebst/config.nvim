-- Enable experimental bytecode caching
vim.loader.enable()

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazy_path,
    }
end
vim.opt.rtp:prepend(lazy_path)

local lazy_ok, lazy = pcall(require, "lazy")
if not lazy_ok then
    return
end

require("config.options")

lazy.setup({
    { import = "plugins" },
}, {
    ui = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
})

require("config.keymaps")
