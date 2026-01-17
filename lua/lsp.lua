-- LSP Configuration using Neovim's built-in API

-- Configure lua_ls
vim.lsp.config.lua_ls = {
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/lua-language-server" },
    root_markers = { ".git" },
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    }
}

vim.lsp.enable({
    "lua_ls",
})
