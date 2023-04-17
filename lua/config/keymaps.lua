-- Keymaps
local which_key = require("which-key")

--- Close window if there multiple, otherwise close buffer.
local function smart_close()
    -- Current window is floating
    if vim.api.nvim_win_get_config(0).relative ~= "" then
        vim.api.nvim_win_close(0, {})
        return
    end

    -- Count non-floating windows
    local wins = 0
    for _, win in pairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == "" then
            wins = wins + 1
        end
    end

    if wins > 1 then
        vim.api.nvim_win_close(0, {})
    else
        vim.api.nvim_buf_delete(0, {})
    end
end

which_key.setup {}

which_key.register {
    j = { "gj", "Down" },
    k = { "gk", "Up" },

    ["<M-j>"] = { "<S-J>", "Join lines" },
    ["<M-k>"] = { "<S-K>", "Look up help" },
    ["<S-j>"] = { "10j", "Down 10 lines" },
    ["<S-k>"] = { "10k", "Up 10 lines" },

    ["<C-s>"] = { "<CMD>vsplit<CR>", "Split window vertically" },

    ["<C-h>"] = { "<C-w>h", "Window left" },
    ["<C-j>"] = { "<C-w>j", "Window down" },
    ["<C-k>"] = { "<C-w>k", "Window up" },
    ["<C-l>"] = { "<C-w>l", "Window right" },

    ["<S-h>"] = { "<CMD>bprev<CR>", "Previous buffer" },
    ["<S-l>"] = { "<CMD>bnext<CR>", "Next buffer" },
    ["<M-q>"] = { "<S-q>", "Repeat last recorded register" },
    ["<S-q>"] = { smart_close, "Smart close window/buffer" },

    ["<TAB>"] = { "%", "Matching character: '()', '{}', '[]'" },

    ["<C-n>"] = { "<CMD>NvimTreeToggle<CR>", "Toggle file browser" },
    ["<C-t>"] = { "<CMD>OverseerToggle<CR>", "Toggle task list" },

    s = { "<CMD>lua require('leap').leap{}<CR>", "Search character" },
    ["<S-s>"] = { "<CMD>lua require('leap').leap{backward=true}<CR>", "Search characters (backwards)" },

    ["<C-\\>"] = { "Open terminal" },

    ["<LEADER>"] = {
        ["<SPACE>"] = { "<CMD>nohlsearch<CR>", "Clear search highlights" },

        ["1"] = { "<CMD>GrappleSelect key=1<CR>", "Jump to file 1" },
        ["2"] = { "<CMD>GrappleSelect key=2<CR>", "Jump to file 2" },
        ["3"] = { "<CMD>GrappleSelect key=3<CR>", "Jump to file 3" },
        ["4"] = { "<CMD>GrappleSelect key=4<CR>", "Jump to file 4" },

        m = {
            name = "Grapple",
            t = { "<CMD>GrappleToggle<CR>", "Toggle" },
            m = { "<CMD>GrapplePopup tags<CR>", "Show menu" },
        },

        b = {
            name = "Debugging",
            c = { "<CMD>lua require('dap').continue()<CR>", "Run / continue" },
            e = { ":e .debug_args.lua<CR>", "Edit config" },
            b = { "<CMD>lua require('dap').toggle_breakpoint()<CR>", "Toggle breakpoint" },
            l = { "<CMD>DapLogpoint<CR>", "Set logpoint" },
            L = { "<CMD>DapConditionalLogpoint<CR>", "Set conditional logpoint" },
            B = { "<CMD>DapConditionalBreakpoint<CR>", "Set conditional breakpoint" },
            s = { "<CMD>lua require('dap').step_over()<CR>", "Step over" },
            i = { "<CMD>lua require('dap').step_into()<CR>", "Step into" },
            o = { "<CMD>lua require('dap').step_out()<CR>", "Step out" },
            q = {
                "<CMD>lua require('dap').terminate()<CR><CMD>DapVirtualTextForceRefresh<CR>",
                "Quit",
            },
            h = { "<CMD>lua require('dap.ui.widgets').hover()<CR>", "Hover" },
            r = { "<CMD>lua require('dap').repl.open()<CR>", "Open REPL" },
        },

        s = { "<CMD>lua require('luasnip.loaders').edit_snippet_files()<CR>", "Edit snippets" },

        h = { "<CMD>lua vim.lsp.buf.hover()<CR>", "Hover" },
        d = { "<CMD>lua require('lsp_lines').toggle()<CR>", "Toggle diagnostics" },
        l = {
            name = "LSP",
            n = { "<CMD>lua vim.lsp.buf.rename()<CR>", "Rename" },
            a = { "<CMD>lua vim.lsp.buf.code_action()<CR>", "Code actions" },
            b = {
                "<CMD>lua require('telescope.builtin').lsp_document_symbols()<CR>",
                "Document symbols",
            },
            s = {
                "<CMD>lua require('telescope.builtin').lsp_workspace_symbols()<CR>",
                "Workspace symbols",
            },
            r = { "<CMD>lua require('telescope.builtin').lsp_references()<CR>", "References" },
            i = {
                "<CMD>lua require('telescope.builtin').lsp_implementations()<CR>",
                "Implementations",
            },
            d = { "<CMD>lua require('telescope.builtin').lsp_definitions()<CR>", "Definitions" },
            t = {
                "<CMD>lua require('telescope.builtin').lsp_type_definitions()<CR>",
                "Type definitions",
            },
            f = { "<CMD>lua vim.lsp.buf.format{async = true}<CR>", "Format" },
            h = { "<CMD>ClangdSwitchSourceHeader<CR>", "Switch source/header" },
        },

        f = {
            name = "Telescope",
            d = { "<CMD>lua require('telescope.builtin').diagnostics()<CR>", "Diagnostics" },
            f = { "<CMD>lua require('telescope.builtin').find_files()<CR>", "Files" },
            g = { "<CMD>lua require('telescope.builtin').live_grep()<CR>", "Live grep" },
            b = { "<CMD>lua require('telescope.builtin').buffers()<CR>", "Buffers" },
            h = { "<CMD>lua require('telescope.builtin').help_tags()<CR>", "Help" },
            w = {
                "<CMD>lua require('telescope').extensions.project.project{display_type = 'full'}<CR>",
                "Workspaces",
            },
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
        },

        o = {
            name = "Overseer",

            a = { "<CMD>OverseerTaskAction<CR>", "Task action" },
            q = { "<CMD>OverseerQuickAction<CR>", "Quick action" },
            r = { "<CMD>OverseerRun<CR>", "Run task" },
            t = { "<CMD>OverseerToggle<CR>", "Toggle task list" },
            b = { "<CMD>OverseerBuild<CR>", "Build task" },
            l = { "<CMD>OverseerLoadBundle<CR>", "Load task bundle" },
            s = { "<CMD>OverseerSaveBundle<CR>", "Save task bundle" },
        },
    },
}

which_key.register({
    ["<M-j>"] = { "<S-j>", "Join lines" },
    ["<S-j>"] = { "10j", "Down 10 lines" },
    ["<S-k>"] = { "10k", "Up 10 lines" },

    ["<TAB>"] = { "%", "Matching character: '()', '{}', '[]'" },

    ["<LEADER>"] = {
        p = {
            name = "Profiling",
            a = { "<CMD>PerfAnnotate<CR>", "Annotate" },
            c = { "<CMD>PerfHottestCallersSelection<CR>", "Hottest callers" },
        },
    },
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
    s = { "<Plug>(leap-forward-to)", "Search character" },
    ["<S-s>"] = { "<Plug>(leap-backward-to)", "Search character (backward)" },
}, { mode = "x" })
