local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "tanvirtin/monokai.nvim",
    -- Vscode-like pictograms
	{
		"onsails/lspkind.nvim",
		event = { "VimEnter" },
	},
	-- Auto-completion engine
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"lspkind.nvim",
			"hrsh7th/cmp-nvim-lsp", -- lsp auto-completion
			"hrsh7th/cmp-buffer", -- buffer auto-completion
			"hrsh7th/cmp-path", -- path auto-completion
			"hrsh7th/cmp-cmdline", -- cmdline auto-completion
		},
		config = function()
			require("config.nvim-cmp")
		end,
	},
	-- Code snippet engine
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
	},
	-- LSP manager
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
    {
        "p00f/clangd_extensions.nvim", 
        config = function()
            require("clangd_extensions").setup({
                server = {
                    cmd = { "clangd",
                            "--query-driver='wsl \'~/.toolchain/tms570/v0.0.0/bin/armeb-none-eabi-gcc\''"
                    },
                    on_attach = on_attach
                }
            })
        end
    },
    -- Telescope
    {
        "nvim-telescope/telescope.nvim", tag = '0.1.8',
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            local install = require("nvim-treesitter.install")

            configs.setup({
                ensure_installed = { "c", "lua", "python" },
                sync_install = false,
                indent = { enable = true },
                highlight = { enable = true },
            })
            install.prefer_git = false
            install.compilers = { "wsl '~/.toolchain/tms570/v0.0.0/bin/armeb-none-eabi-gcc'", "gcc", "clang" }
        end
    }, 
    -- Nvim Tree 
    { 
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                filters = {
                    git_ignored = false,
                    dotfiles = false,
                }
            })
        end
    }
})

