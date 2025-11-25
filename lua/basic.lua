-- basic.lua
--
-- 防止 Lua LSP 提示 Undefined global 'vim'
_G.vim = vim

-- =========================
-- 编码
-- =========================
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"

-- =========================
-- 界面
-- =========================
vim.o.number = true                -- 显示行号
vim.wo.relativenumber = true       -- 相对行号
vim.o.scrolloff = 4                -- 光标上下留出空间
vim.o.sidescrolloff = 4            -- 左右留出空间
vim.wo.cursorline = true           -- 高亮当前行
vim.o.showtabline = 2              -- 总是显示 tabline
vim.o.showmode = false             -- 隐藏底部模式提示（配合 lualine）
vim.wo.signcolumn = "yes"          -- 保留边栏
vim.wo.colorcolumn = ""            -- 不显示参考线
vim.o.termguicolors = true         -- 开启真彩色

-- =========================
-- 文件 & 缓冲区
-- =========================
vim.opt.swapfile = false           -- 禁用 swap
vim.o.hidden = true                -- 允许隐藏已修改 buffer

-- =========================
-- 缩进 & Tab
-- =========================
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.softtabstop = 4
vim.bo.softtabstop = 4
vim.o.shiftround = true
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true

-- =========================
-- 搜索
-- =========================
vim.o.ignorecase = true            -- 搜索大小写不敏感
vim.o.smartcase = true             -- 智能大小写
vim.o.incsearch = true             -- 边输入边搜索

-- =========================
-- 输入 & 编辑
-- =========================
vim.o.mouse = "a"                  -- 启用鼠标
vim.o.completeopt = "menu,menuone,noselect" -- 补全菜单行为

-- =========================
-- 性能
-- =========================
vim.o.timeoutlen = 500             -- 按键超时时间
vim.opt.updatetime = 400           -- 空闲触发时间

-- =========================
-- 禁用 viminfo/shada 文件
-- =========================
vim.o.shadafile = "NONE"           -- 禁用 shada 文件（Neovim 版本的 viminfo）
vim.o.viminfo = ""                 -- 禁用 viminfo 文件

-- =========================
-- 剪贴板
-- =========================
vim.o.clipboard = "unnamedplus"

-- =========================
-- 会在有错误的位置显示
-- =========================
vim.fn.sign_define("DiagnosticSignError", { text = "✘", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "▲", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "ℹ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "➤", texthl = "DiagnosticSignHint" })

-- vim.o.number = true
-- vim.o.relativenumber = true
-- vim.o.cursorline = true
-- vim.o.termguicolors = true
-- vim.o.expandtab = true
-- vim.o.shiftwidth = 4
-- vim.o.tabstop = 4
-- vim.o.smartindent = true
-- vim.o.clipboard = "unnamedplus"
-- vim.o.updatetime = 300
