local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "<Esc>", ":nohlsearch<CR><Esc>", opt)
map("t", "<Esc><Esc>", "<C-\\><C-n>", opt)

map("n", "ww", ":w<CR>", opt)
map("n", "qq", ":SmartCloseBuffer<CR>", opt)
map("n", "wq", ":w<CR> | :SmartCloseBuffer<CR>", opt)

map("n", "<Tab>", ":BufferLineCycleNext<CR>", opt)
map("n", "<Tab>h", ":BufferLineCyclePrev<CR>", opt)

map("n", "<C-h>", "<C-w>h", opt)
map("n", "<C-j>", "<C-w>j", opt)
map("n", "<C-k>", "<C-w>k", opt)
map("n", "<C-l>", "<C-w>l", opt)

map("t", "<C-h>", "<C-\\><C-n><C-w>h", opt)
map("t", "<C-k>", "<C-\\><C-n><C-w>k", opt)
map("t", "<C-l>", "<C-\\><C-n><C-w>l", opt)

map("n", "<C-p>", ":Telescope find_files<CR>", opt)
map("n", "<C-f>", ":Telescope live_grep<CR>", opt)

map("n", "<Space>p", ":VSCodeCommandPalette<CR>", opt)
map("n", "<F1>", ":VSCodeCommandPalette<CR>", opt)
map("i", "<F1>", "<C-o>:VSCodeCommandPalette<CR>", opt)
map("t", "<F1>", "<C-\\><C-n>:VSCodeCommandPalette<CR>", opt)

map("n", "<Space>oc", ":OpenCodeToggle<CR>", opt)
map("n", "<C-`>", ":OpenCodeToggle<CR>", opt)
map("i", "<C-`>", "<C-o>:OpenCodeToggle<CR>", opt)
map("t", "<C-`>", "<C-\\><C-n>:OpenCodeToggle<CR>", opt)

map("n", "<leader>th", ":SelectTheme<CR>", opt)
map("n", "<leader>dl", ":DevLayout<CR>", opt)
map("n", "<C-t>", ":NvimTreeToggle<CR>", opt)
map("t", "<C-t>", "<C-\\><C-n>:NvimTreeToggle<CR>", opt)
map("n", "<C-t>r", ":NvimTreeToggle<CR>", opt)
map("n", "gith", ":Telescope git_commits<CR>", opt)

map("n", "<A-Up>", ":resize +2<CR>", opt)
map("n", "<A-Down>", ":resize -2<CR>", opt)
map("n", "<A-Left>", ":vertical resize -2<CR>", opt)
map("n", "<A-Right>", ":vertical resize +2<CR>", opt)

map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opt)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR><cmd>cclose<CR>", opt)
map("n", "<C-A-l>", "<cmd>lua vim.lsp.buf.format({ async = false })<CR><cmd>normal! gg=G<CR>", opts)

map("n", "gam", ":lua GitAddCommit()<CR>", opt)
map("n", "gp", ":lua GitPush()<CR>", opt)
map("n", "zz", ":foldclose<CR>", opt)
map("n", "zf", ":foldopen<CR>", opt)
