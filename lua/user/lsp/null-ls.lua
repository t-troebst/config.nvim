local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then return end

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.flake8.with(require("user.lsp.settings.flake8")),
        null_ls.builtins.diagnostics.mypy.with(require("user.lsp.settings.mypy"))
    },
    log_level = "debug"
})
