-- Plugins

local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer - close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float{border = "rounded"}
        end,
    },
}

return packer.startup(function(use)
    -- Basic plugins
    use "wbthomason/packer.nvim" -- Have packer manage itself
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins

    -- Basic editor functionality
    use "nvim-lualine/lualine.nvim" -- Fancy status line
    use {"akinsho/bufferline.nvim", branch = "main"} -- Buffer line
    use "kyazdani42/nvim-web-devicons" -- Nice icons for Nvim tree and other plugins
    use "numToStr/Comment.nvim" -- Automatic commenting
    use "phaazon/hop.nvim" -- Character jumping ala EasyMotion
    use {"akinsho/toggleterm.nvim", branch = "main"} -- Terminal support
    use "lewis6991/gitsigns.nvim" -- Git signs
    use "tpope/vim-fugitive" -- Git integration
    use "stevearc/dressing.nvim" -- Nicer select / input windows
    use "kyazdani42/nvim-tree.lua" -- File browser
    use "natecraddock/workspaces.nvim" -- Workspace management

    -- Fuzzy searching
    use "nvim-telescope/telescope.nvim" -- Telescope
    use "natecraddock/telescope-zf-native.nvim" -- Better matches for files

    -- Colorscheme
    use {"rose-pine/neovim", as = "rose-pine.nvim"}

    -- Completion
    use "hrsh7th/nvim-cmp" -- Basic completions
    use "hrsh7th/cmp-buffer" -- Buffer completions
    use "hrsh7th/cmp-path" -- Path completions
    use "hrsh7th/cmp-nvim-lsp" -- LSP completions
    use "hrsh7th/cmp-nvim-lua" -- Lua completions
    use "hrsh7th/cmp-nvim-lsp-signature-help" -- Display signature while typing
    use "saadparwaiz1/cmp_luasnip" -- Snippet completions
    use "onsails/lspkind-nvim" -- Kind icons for lsp completions
    -- TODO: look into this one
    -- use "hrsh7th/cmp-cmdline" -- Command line completions

    -- Snippets
    use "L3MON4D3/LuaSnip" --snippet engine

    -- Language features
    use "neovim/nvim-lspconfig" -- Enable native LSP (language servers)
    use "williamboman/nvim-lsp-installer" -- Simple to use language server installer
    use "mfussenegger/nvim-dap" -- DAP (debugging servers)
    use "theHamsta/nvim-dap-virtual-text" -- Local variables are displayed through virtual text
    use "t-troebst/perfanno.nvim" -- Annotate source code with profiling information from perf

    -- Treesitter (syntax highlighting)
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use "p00f/nvim-ts-rainbow" -- Rainbow brackets
    use "JoosepAlviste/nvim-ts-context-commentstring" -- Correct comments for sub-languages

    -- Plugin Development
    --  use "~/Documents/Projects/perfanno.nvim"
    use "nvim-treesitter/playground" -- Useful for debugging of treesitter
    use "dstein64/vim-startuptime" -- Measure startup time of neovim

    -- Automatically set up configuration after cloning packer.nvim
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
