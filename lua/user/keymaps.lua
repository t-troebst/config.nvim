-- Keymaps

local opts = {noremap = true, silent = true}
local keymap = vim.api.nvim_set_keymap

vim.g.mapleader = ","
vim.g.maplocalleader = ";"

-- Basics

keymap("n", "j", "gj", opts)
keymap("n", "k", "gk", opts)

keymap("n", "<S-b>", "^", opts)
keymap("n", "<S-e>", "$", opts)
keymap("x", "<S-b>", "^", opts)
keymap("x", "<S-e>", "$", opts)

keymap("n", "<S-j>", "10j", opts)
keymap("n", "<S-k>", "10k", opts)
keymap("v", "<S-j>", "10j", opts)
keymap("v", "<S-k>", "10k", opts)

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<S-h>", ":bprev<CR>", opts)
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-q>", ":bd<CR>", opts)

keymap("n", "<TAB>", "%", opts)
keymap("v", "<TAB>", "%", opts)

keymap("i", "jk", "<ESC>", opts)
keymap("s", "jk", "<ESC>", opts)

keymap("n", "<LEADER><SPACE>", ":nohlsearch<CR>", opts)

-- Plugins

keymap("n", "<C-n>", ":NvimTreeToggle<CR>", opts)

keymap("n", "s", ":HopChar1<CR>", opts)
keymap("n", "<S-s>", ":HopChar2<CR>", opts)
keymap("x", "s", "<CMD>HopChar1<CR>", opts)
keymap("x", "<S-s>", "<CMD>HopChar2<CR>", opts)

-- Debugging keybinds

keymap("n", "<F5>", ":lua require('dap').continue()<CR>", opts)
keymap("n", "<F6>", ":lua require('dap').toggle_breakpoint()<CR>", opts)
keymap("n", "<F7>", ":lua require('dap').step_over()<CR>", opts)
keymap("n", "<F8>", ":lua require('dap').step_into()<CR>", opts)
keymap("n", "<F9>", ":lua require('dap').step_out()<CR>", opts)

keymap("n", "<LEADER>bc", ":lua require('dap').continue()<CR>", opts)
keymap("n", "<LEADER>bb", ":lua require('dap').toggle_breakpoint()<CR>", opts)
keymap("n", "<LEADER>bs", ":lua require('dap').step_over()<CR>", opts)
keymap("n", "<LEADER>bi", ":lua require('dap').step_into()<CR>", opts)
keymap("n", "<LEADER>bo", ":lua require('dap').step_out()<CR>", opts)

keymap("n", "<LEADER>bq", ":lua require('dap').terminate()<CR>:DapVirtualTextForceRefresh<CR>", opts)
keymap("n", "<LEADER>bh", ":lua require('dap.ui.widgets').hover()<CR>", opts)
keymap("n", "<LEADER>br", ":lua require('dap').repl.open()<CR>", opts)

-- Snippets

local ls_opts = {silent = true}

keymap("i", "<C-k>", "<Plug>luasnip-expand-or-jump", ls_opts)
keymap("s", "<C-k>", "<Plug>luasnip-expand-or-jump", ls_opts)

keymap("i", "<C-j>", "<Plug>luasnip-jump-prev", ls_opts)
keymap("s", "<C-j>", "<Plug>luasnip-jump-prev", ls_opts)

keymap("i", "<C-l>", "<Plug>luasnip-next-choice", ls_opts)
keymap("s", "<C-l>", "<Plug>luasnip-next-choice", ls_opts)

keymap("n", "<LEADER>se", ":execute \"edit ~/.config/nvim/lua/user/snippets/\" . &ft . \".lua\"<CR>", opts)
keymap("n", "<LEADER>ss", ":source ~/.config/nvim/lua/user/snippets/init.lua<CR>", opts)

-- LSP

keymap("n", "<LEADER>h", ":lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "<LEADER>d", ':lua vim.diagnostic.open_float({ border = "rounded", focus = false })<CR>', opts)
keymap("n", "<LEADER>ln", ":lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "<LEADER>la", ":lua require('telescope.builtin').lsp_code_actions()<CR>", opts)
keymap("n", "<LEADER>lb", ":lua require('telescope.builtin').lsp_document_symbols()<CR>", opts)
keymap("n", "<LEADER>ls", ":lua require('telescope.builtin').lsp_workspace_symbols()<CR>", opts)
keymap("n", "<LEADER>lr", ":lua require('telescope.builtin').lsp_references()<CR>", opts)
keymap("n", "<LEADER>li", ":lua require('telescope.builtin').lsp_implementations()<CR>", opts)
keymap("n", "<LEADER>ld", ":lua require('telescope.builtin').lsp_definitions()<CR>", opts)
keymap("n", "<LEADER>lt", ":lua require('telescope.builtin').lsp_type_definitions()<CR>", opts)
keymap("n", "<LEADER>lf", ":lua vim.lsp.buf.formatting()<CR>", opts)

-- Fuzzy searching

keymap("n", "<LEADER>fd", ":lua require('telescope.builtin').diagnostics()<CR>", opts)
keymap("n", "<LEADER>ff", ":lua require('telescope.builtin').find_files()<CR>", opts)
keymap("n", "<LEADER>fg", ":lua require('telescope.builtin').live_grep()<CR>", opts)
keymap("n", "<LEADER>fc", ":lua require('telescope.builtin').git_status()<CR>", opts)
keymap("n", "<LEADER>fb", ":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", opts)
keymap("n", "<LEADER>fh", ":lua require('telescope.builtin').help_tags()<CR>", opts)
keymap("n", "<LEADER>ft", ":lua require('telescope.builtin').treesitter()<CR>", opts)

-- Git

keymap("n", "<LEADER>gb", ":Gitsigns stage_buffer<CR>", opts)
keymap("n", "<LEADER>gh", ":Gitsigns stage_hunk<CR>", opts)
keymap("n", "<LEADER>gc", ":Git commit<CR>", opts)
keymap("n", "<LEADER>gr", ":Gitsigns reset_buffer<CR>", opts)

-- Perf Annotations

keymap("n", "<LEADER>plf", ":PerfLoadFlat<CR>", opts)
keymap("n", "<LEADER>plg", ":PerfLoadCallGraph<CR>", opts)
keymap("n", "<LEADER>plo", ":PerfLoadFlameGraph<CR>", opts)

keymap("n", "<LEADER>pe", ":PerfPickEvent<CR>", opts)

keymap("n", "<LEADER>pa", ":PerfAnnotate<CR>", opts)
keymap("n", "<LEADER>pf", ":PerfAnnotateFunction<CR>", opts)
keymap("v", "<LEADER>pa", ":PerfAnnotateSelection<CR>", opts)

keymap("n", "<LEADER>pt", ":PerfToggleAnnotations<CR>", opts)

keymap("n", "<LEADER>ph", ":PerfHottestLines<CR>", opts)
keymap("n", "<LEADER>ps", ":PerfHottestSymbols<CR>", opts)
keymap("n", "<LEADER>pc", ":PerfHottestCallersFunction<CR>", opts)
keymap("v", "<LEADER>pc", ":PerfHottestCallersSelection<CR>", opts)

