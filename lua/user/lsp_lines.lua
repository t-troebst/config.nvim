local lsp_lines = require("lsp_lines")

lsp_lines.setup()

vim.diagnostic.config {
    virtual_text = true,
    virtual_lines = false,
}
