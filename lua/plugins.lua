-- plugins.lua
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'windwp/nvim-autopairs'
    use 'kyazdani42/nvim-tree.lua'
    use 'lewis6991/gitsigns.nvim'
    use 'nvim-lualine/lualine.nvim'
    use 'glepnir/lspsaga.nvim'
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'preservim/tagbar"' -- 显示文件定义方法
    use 'nvim-lua/plenary.nvim'
    use {
        "nvimtools/none-ls.nvim",
        -- requires = { "nvim-lua/plenary.nvim" },
        -- config = function()
        --     require("plugin-config.null-ls")
        -- end,
    }
    use "windwp/nvim-autopairs"
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'mfussenegger/nvim-dap'
    use 'rafamadriz/friendly-snippets'
    use 'rcarriga/nvim-dap-ui'
    use 'nvim-tree/nvim-web-devicons'
    use 'numToStr/Comment.nvim'
    -- use 'folke/tokyonight.nvim'
    use 'morhetz/gruvbox'
    use 'mfussenegger/nvim-dap-python'
    use 'glepnir/dashboard-nvim' -- 面板
    -- AI 插件
    -- use 'jackMort/ChatGPT.nvim'
    -- bufferline
    use {
        'akinsho/bufferline.nvim',
        tag = "*",
        requires = 'nvim-tree/nvim-web-devicons' }

    use 'moll/vim-bbye'

end)
