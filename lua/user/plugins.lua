-- Plugins

local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print("Installing packer - close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "plugins.lua" },
    group = vim.api.nvim_create_augroup("PackerSync", { clear = true }),
    callback = function(args)
        dofile(args.file)
        packer.sync()
    end,
})

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

return packer.startup(function(use)
    -- Basic plugins
    use("wbthomason/packer.nvim") -- Have packer manage itself
    use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
    use("nvim-lua/plenary.nvim") -- Useful lua functions used by lots of plugins

    -- Basic editor functionality
    use("nvim-lualine/lualine.nvim") -- Fancy status line
    use { "akinsho/bufferline.nvim", branch = "main" } -- Buffer line
    use("kyazdani42/nvim-web-devicons") -- Nice icons for Nvim tree and other plugins
    use("numToStr/Comment.nvim") -- Automatic commenting
    use("phaazon/hop.nvim") -- Character jumping ala EasyMotion
    use { "akinsho/toggleterm.nvim", branch = "main" } -- Terminal support
    use("lewis6991/gitsigns.nvim") -- Git signs
    use("tpope/vim-fugitive") -- Git integration
    use("stevearc/dressing.nvim") -- Nicer select / input windows
    use("kyazdani42/nvim-tree.lua") -- File browser
    use("folke/which-key.nvim") -- Show keybinds
    use("stevearc/overseer.nvim") -- Task runner
    use("rcarriga/nvim-notify") -- Fancy notification manager

    -- Fuzzy searching
    use("nvim-telescope/telescope.nvim") -- Telescope
    use("natecraddock/telescope-zf-native.nvim") -- Better matches for files
    use {
        "nvim-telescope/telescope-frecency.nvim", -- Recently used files
        requires = { "kkharji/sqlite.lua" },
    }
    use("nvim-telescope/telescope-project.nvim") -- Projects

    -- Colorscheme
    use { "rose-pine/neovim", as = "rose-pine.nvim" }

    -- Completion
    use("hrsh7th/nvim-cmp") -- Basic completions
    use("hrsh7th/cmp-buffer") -- Buffer completions
    use("hrsh7th/cmp-path") -- Path completions
    use("hrsh7th/cmp-nvim-lsp") -- LSP completions
    use("hrsh7th/cmp-nvim-lua") -- Lua completions
    use("hrsh7th/cmp-nvim-lsp-signature-help") -- Display signature while typing
    use("saadparwaiz1/cmp_luasnip") -- Snippet completions
    use("onsails/lspkind-nvim") -- Kind icons for lsp completions
    -- TODO: look into this one
    -- use "hrsh7th/cmp-cmdline" -- Command line completions

    -- Snippets
    use("L3MON4D3/LuaSnip") --snippet engine

    -- Language features
    use("neovim/nvim-lspconfig") -- Enable native LSP (language servers)
    use("Maan2003/lsp_lines.nvim") -- Show LSP diagnostics across multiple lines
    use("jose-elias-alvarez/null-ls.nvim") -- Integrate linters / formatters / etc.
    use("williamboman/mason.nvim") -- Installer for language servers etc.
    use("williamboman/mason-lspconfig.nvim") -- Integration of Mason with LspConfig
    use("mfussenegger/nvim-dap") -- DAP (debugging servers)
    use("theHamsta/nvim-dap-virtual-text") -- Local variables are displayed through virtual text
    use("t-troebst/perfanno.nvim") -- Annotate source code with profiling information from perf

    -- Treesitter (syntax highlighting)
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use("JoosepAlviste/nvim-ts-context-commentstring") -- Correct comments for sub-languages
    use("nvim-treesitter/nvim-treesitter-textobjects") -- Textobjects based on treesitter

    -- Plugin Development
    --  use "~/Documents/Projects/perfanno.nvim"
    use("dstein64/vim-startuptime") -- Measure startup time of neovim

    -- Automatically set up configuration after cloning packer.nvim
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
