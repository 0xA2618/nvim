-- init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("plugins")
require("basic")
require("colorscheme")
require("keymappings")

require("plugin-config.nvim-treesitter")
require("plugin-config.nvim-tree")
require("plugin-config.autopairs")
require("plugin-config.telescope")
require("plugin-config.highlight")
require("plugin-config.bufferline")
require("plugin-config.git-signs")
require("plugin-config.lualine")

require("lsp.cmp")
require("lsp.ui")
require("lsp.setup")

require("plugin-config.lspsaga")
require("plugin-config.rust_analyzer")
require("plugin-config.python")
require("plugin-config.null-ls")
require("plugin-config.tagbar")
-- require("plugin-config.ai")
require("lsp.dap")
-- 设置 GUI 字体（可选，主要针对 Neovim GUI）
vim.opt.guifont = "Hack Nerd Font:h12"

-- 确保终端支持图标
vim.g.nerdfont = true
