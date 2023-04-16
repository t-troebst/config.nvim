local function has_config(name)
    return vim.fn.findfile(name, ".;") ~= ""
end

local function get_config(name)
    local file = vim.fn.findfile(name, ".;")
    return vim.fn.fnamemodify(file, ":p")
end

return {
    { "williamboman/mason.nvim",           build = ":MasonUpdate", config = true },
    { "williamboman/mason-lspconfig.nvim", config = true },
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup {
                sources = {
                    null_ls.builtins.diagnostics.flake8.with {
                        condition = function()
                            return has_config("flake8.ini")
                        end,
                        extra_args = function()
                            return { "--append-config", get_config("flake8.ini") }
                        end,
                    },
                    null_ls.builtins.diagnostics.mypy.with {
                        extra_args = function()
                            local file = get_config("mypy.ini")
                            if file ~= "" then
                                return { "--config-file", file }
                            end
                        end,
                    },
                    null_ls.builtins.formatting.stylua,
                },
            }
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            diagnostics = {
                -- disable virtual text
                virtual_text = false,
                -- show signs
                signs = {
                    active = {
                        { name = "DiagnosticSignError", text = "" },
                        { name = "DiagnosticSignWarn",  text = "" },
                        { name = "DiagnosticSignHint",  text = "" },
                        { name = "DiagnosticSignInfo",  text = "" },
                    },
                },
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            },
            servers = {
                clangd = {
                    cmd = {
                        "clangd",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                    },
                    fallbackFlags = {
                        "-std=c++20",
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                library = {
                                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                    [vim.fn.stdpath("config") .. "/lua"] = true,
                                },
                            },
                        },
                    },
                },
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "off",
                            },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            local nvim_lspconfig = require("lspconfig")

            for _, sign in ipairs(opts.diagnostics.signs.active) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            end

            vim.diagnostic.config(opts.diagnostics)
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            })

            vim.lsp.handlers["textDocument/signatureHelp"] =
                vim.lsp.with(vim.lsp.handlers.signature_help, {
                    border = "rounded",
                })

            local augroup = vim.api.nvim_create_augroup("LspHighlighting", { clear = false })

            local ext = {
                on_attach = function(client, bufnr)
                    if client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
                        vim.api.nvim_create_autocmd("CursorHold", {
                            group = augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd("CursorMoved", {
                            group = augroup,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
                capabilities = require("cmp_nvim_lsp").default_capabilities(
                    vim.lsp.protocol.make_client_capabilities()
                ),
            }

            for server, settings in pairs(opts.servers) do
                nvim_lspconfig[server].setup(vim.tbl_deep_extend("force", settings, ext))
            end
        end,
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup {}
            vim.diagnostic.config {
                virtual_text = true,
                virtual_lines = false,
            }
        end,
        lazy = true,
    },
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        config = true,
    },
}
