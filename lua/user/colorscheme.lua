-- Colorscheme

local palette = require("rose-pine.palette")

vim.cmd [[colorscheme rose-pine]]

-- Semantic highlighting

vim.api.nvim_set_hl(0, "@lsp.typemod.function.defaultLibrary.lua", { link = "@function.builtin" })
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.defaultLibrary.cpp", { link = "@lsp" })
vim.api.nvim_set_hl(0, "@lsp.typemod.function.defaultLibrary.cpp", { link = "@lsp" })

-- Custom highlights for DAP

vim.api.nvim_set_hl(0, "Breakpoint", { fg = palette.love })
vim.api.nvim_set_hl(0, "Logpoint", { fg = palette.gold })
vim.api.nvim_set_hl(0, "Continue", { fg = palette.pine })

-- Custom highlights for Treesitter

vim.api.nvim_set_hl(0, "@attribute", { fg = palette.muted })
