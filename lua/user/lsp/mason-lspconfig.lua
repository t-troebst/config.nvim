local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

mason_lspconfig.setup()
mason_lspconfig.setup_handlers {
    function(server_name)
        local opts = {
            on_attach = require("user.lsp.handlers").on_attach,
            capabilities = require("user.lsp.handlers").capabilities,
        }

        local settings_ok, settings = pcall(require, "user.lsp.settings." .. server_name)
        if settings_ok then
            lspconfig[server_name].setup(vim.tbl_deep_extend("force", settings, opts))
        else
            lspconfig[server_name].setup(opts)
        end
    end,
}
