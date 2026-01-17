# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

Neovim configuration using lazy.nvim plugin manager. Config symlinks from `~/.config/nvim` to this repo.

**File structure:**
- `init.lua`: Bootstraps lazy.nvim, loads options, runs lazy.setup, loads keymaps
- `lua/options.lua`: All vim options, leader keys (`,` and `;`), autocmds
- `lua/plugins.lua`: Single table of plugin specs
- `lua/keymaps.lua`: All keybindings via which-key.add()

**Key plugins:**
- LSP: mason-lspconfig, blink.cmp (completion)
- Formatting: conform.nvim (stylua for Lua, format-on-save enabled)
- Linting: nvim-lint (ruff for Python)
- UI: rose-pine, lualine, bufferline, nvim-tree (right side)
- Navigation: fzf-lua, grapple, hop.nvim
- Git: fugitive, gitsigns

## Commands

**Format code:**
```bash
stylua .
```

**Plugin management (in Neovim):**
- `:Lazy` - Plugin manager UI
- `:Mason` - LSP/formatter/linter installer

## Patterns

**Add plugin** to `lua/plugins.lua`:
```lua
{ "author/plugin-name", opts = {} }
```

**Add keymap** to `lua/keymaps.lua`:
```lua
which_key.add {
    { "<LEADER>x", "<CMD>Command<CR>", desc = "Description" },
}
```

**Add language support:**
1. Install LSP via `:Mason`
2. Add formatter to conform.nvim config in `lua/plugins.lua` under `formatters_by_ft`
3. Add linter to nvim-lint config in `lua/plugins.lua` under `linters_by_ft`
