-- Keymaps
local which_key_ok, which_key = pcall(require, "which-key")
if not which_key_ok then return end

vim.g.mapleader = ","
vim.g.maplocalleader = ";"

which_key.setup {}

which_key.register({
    j = { "gj", "Down" },
    k = { "gk", "Up" },
    ["<S-j>"] = { "10j", "Down 10 lines" },
    ["<S-k>"] = { "10k", "Up 10 lines" },

    ["<C-h>"] = { "<C-w>h", "Window left" },
    ["<C-j>"] = { "<C-w>j", "Window down" },
    ["<C-k>"] = { "<C-w>k", "Window up" },
    ["<C-l>"] = { "<C-w>l", "Window right" },

    ["<S-h>"] = { "<CMD>bprev<CR>", "Previous buffer" },
    ["<S-l>"] = { "<CMD>bnext<CR>", "Next buffer" },
    ["<S-q>"] = { "<CMD>bd<CR>", "Delete buffer" },

    ["<TAB>"] = { "%", "Matching character: '()', '{}', '[]'" },

    ["<C-n>"] = { "<CMD>NvimTreeToggle<CR>", "Toggle file browser" },

    s = { "<CMD>HopChar1<CR>", "Search character" },
    ["<S-s>"] = { "<CMD>HopChar2<CR>", "Search 2 characters" },

    ["<C-\\>"] = { "Open terminal" },

    ["<LEADER>"] = {
        ["<SPACE>"] = { "<CMD>nohlsearch<CR>", "Clear search highlights" },

        b = {
            name = "Debugging",
            c = { "<CMD>lua require('dap').continue()<CR>", "Run / continue" },
            b = { "<CMD>lua require('dap').toggle_breakpoint()<CR>", "Toggle breakpoint" },
            s = { "<CMD>lua require('dap').step_over()<CR>", "Step over" },
            i = { "<CMD>lua require('dap').step_into()<CR>", "Step into" },
            o = { "<CMD>lua require('dap').step_out()<CR>", "Step out" },
            q = { "<CMD>lua require('dap').terminate()<CR><CMD>DapVirtualTextForceRefresh<CR>", "Quit" },
            h = { "<CMD>lua require('dap.ui.widgets').hover()<CR>", "Hover" },
            r = { "<CMD>lua require('dap').repl.open()<CR>", "Open REPL" },
        },

        s = { "<CMD>lua require('luasnip.loaders').edit_snippet_files()<CR>", "Edit snippets" },

        h = { "<CMD>lua vim.lsp.buf.hover()<CR>", "Hover" },
        d = { "<CMD>lua vim.diagnostic.open_float({border = 'rounded', focus = false})<CR>", "Diagnostics" },
        l = {
            name = "LSP",
            n = { "<CMD>lua vim.lsp.buf.rename()<CR>", "Rename" },
            a = { "<CMD>lua vim.lsp.buf.code_action()<CR>", "Code actions" },
            b = { "<CMD>lua require('telescope.builtin').lsp_document_symbols()<CR>", "Document symbols" },
            s = { "<CMD>lua require('telescope.builtin').lsp_workspace_symbols()<CR>", "Workspace symbols" },
            r = { "<CMD>lua require('telescope.builtin').lsp_references()<CR>", "References" },
            i = { "<CMD>lua require('telescope.builtin').lsp_implementations()<CR>", "Implementations" },
            d = { "<CMD>lua require('telescope.builtin').lsp_definitions()<CR>", "Definitions" },
            t = { "<CMD>lua require('telescope.builtin').lsp_type_definitions()<CR>", "Type definitions" },
            f = { "<CMD>lua vim.lsp.buf.formatting()<CR>", "Format" },
            h = { "<CMD>ClangdSwitchSourceHeader<CR>", "Switch source/header" },
        },

        f = {
            name = "Telescope",
            d = { "<CMD>lua require('telescope.builtin').diagnostics()<CR>", "Diagnostics" },
            f = { "<CMD>lua require('telescope.builtin').find_files()<CR>", "Files" },
            g = { "<CMD>lua require('telescope.builtin').live_grep()<CR>", "Live grep" },
            b = { "<CMD>lua require('telescope.builtin').buffers()<CR>", "Buffers" },
            h = { "<CMD>lua require('telescope.builtin').help_tags()<CR>", "Help" },
            w = { "<CMD>Telescope workspaces<CR>", "Workspaces" },
        },

        g = {
            name = "Git",
            s = {
                name = "Stage",
                f = { "<CMD>lua require('telescope.builtin').git_status()<CR>", "Files" },
                b = { "<CMD>Gitsigns stage_buffer<CR>", "Buffer" },
                h = { "<CMD>Gitsigns stage_hunk<CR>", "Hunk" },
            },
            r = {
                name = "Reset",
                b = { "<CMD>Gitsigns reset_buffer<CR>", "Buffer" },
                h = { "<CMD>Gitsigns reset_hunk<CR>", "Hunk" },
            },
            b = { "<CMD>Git blame<CR>", "Blame" },
            u = { "<CMD>Gitsigns undo_stage_hunk<CR>", "Undo stage hunk" },
            n = { "<CMD>Gitsigns next_hunk<CR>", "Next hunk" },
            p = { "<CMD>Gitsigns prev_hunk<CR>", "Previous hunk" },
            c = { "<CMD>Git commit<CR>", "Commit" },
            h = { "<CMD>Telescope git_bcommits<CR>", "History" },
            d = { "<CMD>Gitsigns diffthis<CR>", "Diff" },
            o = {
                name = "Origin",
                u = { "<CMD>Git push<CR>", "Upload changes" },
                d = { "<CMD>Git pull<CR>", "Download changes" },
                r = { "<CMD>Git rebase<CR>", "Rebase" },
            },
        },

        p = {
            name = "Profiling",
            l = {
                name = "Load",
                f = { "<CMD>PerfLoadFlat<CR>", "Perf flat" },
                g = { "<CMD>PerfLoadCallGraph<CR>", "Perf w/ call graph" },
                o = { "<CMD>PerfLoadFlameGraph<CR>", "Flame graph" },
            },
            e = { "<CMD>PerfPickEvent<CR>", "Pick event" },
            a = { "<CMD>PerfAnnotate<CR>", "Annotate" },
            f = { "<CMD>PerfAnnotateFunction<CR>", "Annotate function" },
            h = { "<CMD>PerfHottestLines<CR>", "Hottest lines" },
            s = { "<CMD>PerfHottestSymbols<CR>", "Hottest symbols" },
            c = { "<CMD>PerfHottestCallersFunction<CR>", "Hottest callers" },
        }
    }
})

which_key.register({
    ["<S-j>"] = { "10j", "Down 10 lines" },
    ["<S-k>"] = { "10k", "Up 10 lines" },

    ["<TAB>"] = { "%", "Matching character: '()', '{}', '[]'" },

    ["<LEADER>"] = {
        p = {
            name = "Profiling",
            a = { "<CMD>PerfAnnotate<CR>", "Annotate" },
            c = { "<CMD>PerfHottestCallersSelection<CR>", "Hottest callers" },
        }
    }
}, { mode = "v" })

which_key.register({
    jk = { "<ESC>", "Normal mode" },

    ["<C-k>"] = { "<Plug>luasnip-expand-or-jump", "Expand / continue snippet" },
    ["<C-j>"] = { "<Plug>luasnip-jump-prev", "Previous snippet position" },
    ["<C-l>"] = { "<Plug>luasnip-next-choice", "Next snippet choice" },
}, { mode = "i" })

which_key.register({
    jk = { "<ESC>", "Normal mode" },

    ["<C-k>"] = { "<Plug>luasnip-expand-or-jump", "Expand / continue snippet" },
    ["<C-j>"] = { "<Plug>luasnip-jump-prev", "Previous snippet position" },
    ["<C-l>"] = { "<Plug>luasnip-next-choice", "Next snippet choice" },
}, { mode = "s" })

which_key.register({
    s = { "<CMD>HopChar1<CR>", "Search character" },
    ["<S-s>"] = { "<CMD>HopChar2<CR>", "Search 2 characters" },
}, { mode = "x" })
