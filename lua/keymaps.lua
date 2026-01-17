-- Keymaps
local which_key = require("which-key")

--- Close window if there multiple, otherwise close buffer.
local function smart_close()
    -- Current window is floating
    if vim.api.nvim_win_get_config(0).relative ~= "" then
        vim.api.nvim_win_close(0, false)
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
        vim.api.nvim_win_close(0, false)
    else
        vim.api.nvim_buf_delete(0, {})
    end
end

which_key.setup {}

which_key.add {
    { "<C-\\>", desc = "Open terminal" },
    {
        "<C-h>",
        "<C-w>h",
        desc = "Window left",
    },
    {
        "<C-j>",
        "<C-w>j",
        desc = "Window down",
    },
    {
        "<C-k>",
        "<C-w>k",
        desc = "Window up",
    },
    {
        "<C-l>",
        "<C-w>l",
        desc = "Window right",
    },
    {
        "<C-n>",
        "<CMD>NvimTreeToggle<CR>",
        desc = "Toggle file browser",
    },
    {
        "<C-s>",
        "<CMD>vsplit<CR>",
        desc = "Split window vertically",
    },
    {
        "<LEADER>1",
        "<CMD>GrappleSelect key=1<CR>",
        desc = "Jump to file 1",
    },
    {
        "<LEADER>2",
        "<CMD>GrappleSelect key=2<CR>",
        desc = "Jump to file 2",
    },
    {
        "<LEADER>3",
        "<CMD>GrappleSelect key=3<CR>",
        desc = "Jump to file 3",
    },
    {
        "<LEADER>4",
        "<CMD>GrappleSelect key=4<CR>",
        desc = "Jump to file 4",
    },
    {
        "<LEADER><SPACE>",
        "<CMD>nohlsearch<CR>",
        desc = "Clear search highlights",
    },
    { "<LEADER>d", group = "Diagnostics" },
    {
        "<LEADER>dh",
        "<CMD>lua vim.diagnostic.open_float()<CR>",
        desc = "Hover",
    },
    {
        "<LEADER>dt",
        "<CMD>lua require('lsp_lines').toggle()<CR>",
        desc = "Toggle diagnostic lines",
    },
    { "<LEADER>f", group = "fzf-lua" },
    {
        "<LEADER>fb",
        "<CMD>lua require('fzf-lua').buffers()<CR>",
        desc = "Buffers",
    },
    {
        "<LEADER>fd",
        "<CMD>lua require('fzf_lua').diagnostics_document()<CR>",
        desc = "Diagnostics",
    },
    {
        "<LEADER>ff",
        "<CMD>lua require('fzf-lua').files()<CR>",
        desc = "Files",
    },
    {
        "<LEADER>fg",
        "<CMD>lua require('fzf-lua').live_grep_native()<CR>",
        desc = "Live grep",
    },
    {
        "<LEADER>fh",
        "<CMD>lua require('fzf-lua').helptags()<CR>",
        desc = "Help",
    },
    { "<LEADER>g", group = "Git" },
    {
        "<LEADER>gb",
        "<CMD>Git blame<CR>",
        desc = "Blame",
    },
    {
        "<LEADER>gc",
        "<CMD>Git commit<CR>",
        desc = "Commit",
    },
    {
        "<LEADER>gd",
        "<CMD>Gitsigns diffthis<CR>",
        desc = "Diff",
    },
    {
        "<LEADER>gh",
        "<CMD>lua require('fzf-lua').git_bcommits()<CR>",
        desc = "History",
    },
    {
        "<LEADER>gn",
        "<CMD>Gitsigns next_hunk<CR>",
        desc = "Next hunk",
    },
    { "<LEADER>go", group = "Origin" },
    {
        "<LEADER>god",
        "<CMD>Git pull<CR>",
        desc = "Download changes",
    },
    {
        "<LEADER>gor",
        "<CMD>Git rebase<CR>",
        desc = "Rebase",
    },
    {
        "<LEADER>gou",
        "<CMD>Git push<CR>",
        desc = "Upload changes",
    },
    {
        "<LEADER>gp",
        "<CMD>Gitsigns prev_hunk<CR>",
        desc = "Previous hunk",
    },
    { "<LEADER>gr", group = "Reset" },
    {
        "<LEADER>grb",
        "<CMD>Gitsigns reset_buffer<CR>",
        desc = "Buffer",
    },
    {
        "<LEADER>grh",
        "<CMD>Gitsigns reset_hunk<CR>",
        desc = "Hunk",
    },
    { "<LEADER>gs", group = "Stage" },
    {
        "<LEADER>gsb",
        "<CMD>Gitsigns stage_buffer<CR>",
        desc = "Buffer",
    },
    {
        "<LEADER>gsf",
        "<CMD>lua require('fzf-lua').git_status()<CR>",
        desc = "Files",
    },
    {
        "<LEADER>gsh",
        "<CMD>Gitsigns stage_hunk<CR>",
        desc = "Hunk",
    },
    {
        "<LEADER>gu",
        "<CMD>Gitsigns undo_stage_hunk<CR>",
        desc = "Undo stage hunk",
    },
    {
        "<LEADER>h",
        "<CMD>lua vim.lsp.buf.hover()<CR>",
        desc = "Hover",
    },
    { "<LEADER>l", group = "LSP" },
    {
        "<LEADER>la",
        "<CMD>lua vim.lsp.buf.code_action()<CR>",
        desc = "Code actions",
    },
    {
        "<LEADER>lb",
        "<CMD>lua require('fzf-lua').lsp_document_symbols()<CR>",
        desc = "Document symbols",
    },
    {
        "<LEADER>ld",
        "<CMD>lua require('fzf-lua').lsp_definitions()<CR>",
        desc = "Definitions",
    },
    {
        "<LEADER>lf",
        "<CMD>lua vim.lsp.buf.format{async = true}<CR>",
        desc = "Format",
    },
    {
        "<LEADER>lh",
        "<CMD>ClangdSwitchSourceHeader<CR>",
        desc = "Switch source/header",
    },
    {
        "<LEADER>li",
        "<CMD>lua require('fzf-lua').lsp_implementations()<CR>",
        desc = "Implementations",
    },
    {
        "<LEADER>ln",
        "<CMD>lua vim.lsp.buf.rename()<CR>",
        desc = "Rename",
    },
    {
        "<LEADER>lr",
        "<CMD>lua require('fzf-lua').lsp_references()<CR>",
        desc = "References",
    },
    {
        "<LEADER>ls",
        "<CMD>lua require('fzf-lua').lsp_workspace_symbols()<CR>",
        desc = "Workspace symbols",
    },
    {
        "<LEADER>lt",
        "<CMD>lua require('fzf-lua').lsp_typedefs()<CR>",
        desc = "Type definitions",
    },
    { "<LEADER>m", group = "Grapple" },
    {
        "<LEADER>m1",
        "<CMD>GrappleTag key=1<CR>",
        desc = "Tag as file 1",
    },
    {
        "<LEADER>m2",
        "<CMD>GrappleTag key=2<CR>",
        desc = "Tag as file 2",
    },
    {
        "<LEADER>m3",
        "<CMD>GrappleTag key=3<CR>",
        desc = "Tag as file 3",
    },
    {
        "<LEADER>m4",
        "<CMD>GrappleTag key=4<CR>",
        desc = "Tag as file 4",
    },
    {
        "<LEADER>mm",
        "<CMD>GrapplePopup tags<CR>",
        desc = "Show menu",
    },
    {
        "<LEADER>mt",
        "<CMD>GrappleToggle<CR>",
        desc = "Toggle",
    },
    { "<LEADER>p", group = "Profiling" },
    {
        "<LEADER>pa",
        "<CMD>PerfAnnotate<CR>",
        desc = "Annotate",
    },
    {
        "<LEADER>pc",
        "<CMD>PerfHottestCallersFunction<CR>",
        desc = "Hottest callers",
    },
    {
        "<LEADER>pe",
        "<CMD>PerfPickEvent<CR>",
        desc = "Pick event",
    },
    {
        "<LEADER>pf",
        "<CMD>PerfAnnotateFunction<CR>",
        desc = "Annotate function",
    },
    {
        "<LEADER>ph",
        "<CMD>PerfHottestLines<CR>",
        desc = "Hottest lines",
    },
    { "<LEADER>pl", group = "Load" },
    {
        "<LEADER>plf",
        "<CMD>PerfLoadFlat<CR>",
        desc = "Perf flat",
    },
    {
        "<LEADER>plg",
        "<CMD>PerfLoadCallGraph<CR>",
        desc = "Perf w/ call graph",
    },
    {
        "<LEADER>plo",
        "<CMD>PerfLoadFlameGraph<CR>",
        desc = "Flame graph",
    },
    {
        "<LEADER>ps",
        "<CMD>PerfHottestSymbols<CR>",
        desc = "Hottest symbols",
    },
    {
        "<M-j>",
        "<S-J>",
        desc = "Join lines",
    },
    {
        "<M-k>",
        "<S-K>",
        desc = "Look up help",
    },
    {
        "<M-q>",
        "<S-q>",
        desc = "Repeat last recorded register",
    },
    {
        "<S-h>",
        "<CMD>bprev<CR>",
        desc = "Previous buffer",
    },
    {
        "<S-j>",
        "10j",
        desc = "Down 10 lines",
    },
    {
        "<S-k>",
        "10k",
        desc = "Up 10 lines",
    },
    {
        "<S-l>",
        "<CMD>bnext<CR>",
        desc = "Next buffer",
    },
    {
        "<S-q>",
        smart_close,
        desc = "Smart close window/buffer",
    },
    {
        "<TAB>",
        "%",
        desc = "Matching character: '()', '{}', '[]'",
    },
    {
        "j",
        "gj",
        desc = "Down",
    },
    {
        "k",
        "gk",
        desc = "Up",
    },
    {
        "s",
        "<CMD>HopChar1<CR>",
        desc = "Search character",
    },
}

which_key.add {
    {
        mode = { "v" },
        { "<LEADER>p", group = "Profiling" },
        { "<LEADER>pa", "<CMD>PerfAnnotate<CR>", desc = "Annotate" },
        { "<LEADER>pc", "<CMD>PerfHottestCallersSelection<CR>", desc = "Hottest callers" },
        { "<M-j>", "<S-j>", desc = "Join lines" },
        { "<S-j>", "10j", desc = "Down 10 lines" },
        { "<S-k>", "10k", desc = "Up 10 lines" },
        {
            "<TAB>",
            "%",
            desc = "Matching character: '()', '{}', '[]'",
        },
    },
}

which_key.add {
    {
        mode = { "i" },
        { "jk", "<ESC>", desc = "Normal mode" },
    },
}

which_key.add {
    {
        mode = { "s" },
        { "jk", "<ESC>", desc = "Normal mode" },
    },
}

which_key.add {
    { "<S-s>", "<Plug>(leap-backward-to)", desc = "Search character (backward)", mode = "x" },
    { "s", "<Plug>(leap-forward-to)", desc = "Search character", mode = "x" },
}

which_key.add {
    {
        mode = { "t" },
        { "<ESC>", "<C-\\><C-n>", desc = "Enter normal mode" },
        { "<PageDown>", "<C-\\><C-n><PageDown>", desc = "Page down" },
        { "<PageUp>", "<C-\\><C-n><PageUp>", desc = "Page up" },
        { "jk", "<C-\\><C-n>", desc = "Enter normal mode" },
    },
}
