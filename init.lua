-- Enable experimental byte-cached Lua loader
vim.loader.enable()

local function protected_load(name)
    local status, error = pcall(require, name)

    if not status then
        vim.notify("Error in " .. name .. ":" .. vim.inspect(error), vim.log.levels.ERROR)
    end
end

protected_load("user.plugins")
protected_load("user.options")
protected_load("user.keymaps")
protected_load("user.colorscheme")
protected_load("user.completion")
protected_load("user.nvimtree")
protected_load("user.luasnip")
protected_load("user.lsp")
protected_load("user.mason")
protected_load("user.treesitter")
protected_load("user.lualine")
protected_load("user.comment")
protected_load("user.bufferline")
protected_load("user.toggleterm")
protected_load("user.telescope")
protected_load("user.dap")
protected_load("user.dapvirtual")
protected_load("user.gitsigns")
protected_load("user.dressing")
protected_load("user.perfanno")
protected_load("user.overseer")
protected_load("user.lsp_lines")
protected_load("user.notify")
protected_load("user.fidget")
