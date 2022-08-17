local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then return end

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.flake8.with({
            extra_args = function(params)
                local file = vim.fn.findfile("flake8.ini", ".;")
                if file ~= "" then
                    return { "--append-config", file }
                end
            end
        }),
        null_ls.builtins.diagnostics.mypy.with({
            extra_args = function(params)
                local file = vim.fn.findfile("mypy.ini", ".;")
                if file ~= "" then
                    return { "--config-file", file }
                end
            end
        })
    },
    log_level = "debug"
})
