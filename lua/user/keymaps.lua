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
keymap("v", "<S-b>", "^", opts)
keymap("v", "<S-e>", "$", opts)

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

keymap("n", "<LEADER><SPACE>", ":nohlsearch<CR>", opts)

-- Plugins

keymap("n", "<C-n>", ":NvimTreeToggle<CR>", opts)

keymap("n", "s", ":HopChar1<CR>", opts)
keymap("v", "s", ":HopChar1<CR>", opts)

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

-- Fuzzy searching

keymap("n", "<LEADER>ff", ":lua require('telescope.builtin').find_files()<CR>", opts)
keymap("n", "<LEADER>fg", ":lua require('telescope.builtin').live_grep()<CR>", opts)
keymap("n", "<LEADER>fb", ":lua require('telescope.builtin').buffers()<CR>", opts)
keymap("n", "<LEADER>fh", ":lua require('telescope.builtin').help_tags()<CR>", opts)