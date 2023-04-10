local null_ls = require("null-ls")

null_ls.setup {
    sources = {
        null_ls.builtins.diagnostics.flake8.with(require("user.lsp.settings.flake8")),
        null_ls.builtins.diagnostics.mypy.with(require("user.lsp.settings.mypy")),
        null_ls.builtins.formatting.stylua.with(require("user.lsp.settings.stylua")),
    },
    log_level = "debug",
}
