local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then return end

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then return end

mason_lspconfig.setup()

local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
}

mason_lspconfig.setup_handlers({
    -- Default handler
    function(server_name)
        local settings_ok, settings = pcall(require, "user.lsp.settings." .. server_name)
        if settings_ok then
            lspconfig[server_name].setup(vim.tbl_deep_extend("force", settings, opts))
        else
            lspconfig[server_name].setup(opts)
        end
    end,
})
