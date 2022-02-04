-- plugins

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
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-- Install your plugins here
return packer.startup(function(use)
    -- Basic plugins
    use "wbthomason/packer.nvim" -- Have packer manage itself
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins

    -- Editor functionality
    use "nvim-lualine/lualine.nvim" -- Fancy status line
    use "akinsho/bufferline.nvim" -- Buffer line
    use "kyazdani42/nvim-tree.lua" -- Nvim file tree / explorer
    use "kyazdani42/nvim-web-devicons" -- Nice icons for Nvim tree
    use "numToStr/Comment.nvim" -- Automatic commenting
    use "bronson/vim-trailing-whitespace" -- Show trailing whitespace
    use "phaazon/hop.nvim" -- Character jumping ala EasyMotion
    use "akinsho/toggleterm.nvim" -- Terminal support
    use "nvim-telescope/telescope.nvim" -- Fuzzy searching

    -- Colorschemes
    use "lunarvim/darkplus.nvim"
    use "EdenEast/nightfox.nvim"
    use "folke/tokyonight.nvim"

    -- Completion
    use "hrsh7th/nvim-cmp" -- Basic completions
    use "hrsh7th/cmp-buffer" -- Buffer completions
    use "hrsh7th/cmp-path" -- Path completions
    use "hrsh7th/cmp-cmdline" -- Command line completions
    use "hrsh7th/cmp-nvim-lsp" -- LSP completions
    use "hrsh7th/cmp-nvim-lua" -- Lua completions
    use "saadparwaiz1/cmp_luasnip" -- Snippet completions

    -- Snippets
    use "L3MON4D3/LuaSnip" --snippet engine
    -- use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    -- LSP & DAP
    use "neovim/nvim-lspconfig" -- Enable native LSP (language servers)
    use "williamboman/nvim-lsp-installer" -- Simple to use language server installer
    use "mfussenegger/nvim-dap" -- DAP (debugging servers)
    use "theHamsta/nvim-dap-virtual-text" -- Local variables are displayed through virtual text comments

    -- Treesitter (syntax highlighting)
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use "p00f/nvim-ts-rainbow" -- Rainbow brackets
    use "JoosepAlviste/nvim-ts-context-commentstring" -- Correct comments for sub-languages

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)