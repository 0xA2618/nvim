-- keymappings.lua
local opts = { noremap = true, silent = true }

-- keymappings.lua

-- 定义 set key map 的快捷函数
local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

-- 设置窗口切换快捷键
-- 普通模式下使用 Tab+h 切换到左边窗口
map('n', '<Tab>h', '<C-w>h', opt)
-- 普通模式下使用 Tab+l 切换到右边窗口
map('n', '<Tab>l', '<C-w>l', opt)
-- 普通模式下使用 Tab+j 切换到下面窗口
map('n', '<Tab>j', '<C-w>j', opt)
-- 普通模式下使用 Tab+k 切换到上面窗口
map('n', '<Tab>k', '<C-w>k', opt)

-- 设置 leader 键为空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =========================
-- 窗口管理
-- =========================
map("n", "s", "", opt)               -- 禁用 s
map("n", "sl", ":vsplit<CR>", opt)   -- 垂直分割
map("n", "sh", ":split<CR>", opt)    -- 水平分割
map("n", "sc", "<C-w>c", opt)        -- 关闭当前窗口
-- map("n", "so", "<C-w>o", opt)     -- 关闭其他窗口

-- 窗口切换
map("n", "<C-j>", "<C-w>j", opt)
map("n", "<C-k>", "<C-w>k", opt)
map("n", "<C-h>", "<C-w>h", opt)
map("n", "<C-l>", "<C-w>l", opt)

-- =========================
-- 文件操作
-- =========================
map("n", "ww", ":w<CR>", opt)        -- 保存
map("n", "rl", ":e!<CR>", opt)       -- 重新加载
map("n", "q", ":Bdelete!<CR>", opt)  -- 关闭 buffer
map("n", "qq", ":q<CR>", opt)        -- 退出窗口
map("n", "wq", ":w<CR> | :Bdelete!<CR>", opt) -- 保存并关闭 buffer

-- =========================
-- 搜索 & 文件导航
-- =========================
map("n", "<Esc>", ":nohlsearch<CR><Esc>", opt) -- 取消高亮

-- 文件树
map("n", "tr", ":NvimTreeToggle<CR>", opt)

-- Telescope
map("n", "<C-p>", ":Telescope find_files<CR>", opt) -- 文件搜索
map("n", "<C-f>", ":Telescope live_grep<CR>", opt)  -- 全局搜索
map("n", "gith", ":Telescope git_commits<CR>", opt) -- Git 提交历史
-- map("n", "gits", ":Telescope git_status<CR>", opt)

-- =========================
-- Git 操作
-- =========================
map("n", "gam", ":lua GitAddCommit()<CR>", opt) -- git add & commit
map("n", "gp", ":lua GitPush()<CR>", opt)       -- git push

-- =========================
-- Bufferline
-- =========================
map("n", "<Tab>h", ":BufferLineCyclePrev<CR>", opt)
map("n", "<Tab>", ":BufferLineCycleNext<CR>", opt)

-- =========================
-- 折叠
-- =========================
map("n", "zz", ":foldclose<CR>", opt)
map("n", "zf", ":foldopen<CR>", opt)

-- =========================
-- LSP 快捷键
-- =========================
map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opt)  -- 跳转定义
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR><cmd>cclose<CR>", opt) -- 引用列表


-- map("n", "<C-A-l>", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opt)
-- 代码格式化
vim.api.nvim_set_keymap("n", "<C-A-l>", "<cmd>lua vim.lsp.buf.format({ async = false })<CR><cmd>normal! gg=G<CR>", opts)

-- 设置 ff 为打开/关闭 tagbar 的快捷键
map("n", "ff", ":TagbarToggle<CR>", opt)
