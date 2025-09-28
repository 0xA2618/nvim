-- colorscheme.lua

-- 设置颜色方案名称
local colorscheme = "gruvbox"
-- local colorscheme = "tokyonight"

-- 尝试加载颜色方案
local ok, err = pcall(vim.cmd, string.format("colorscheme %s", colorscheme))

-- 如果加载失败，发出错误通知并附带错误信息
if not ok then
    vim.notify(
        string.format("Colorscheme '%s' not found: %s", colorscheme, err),
        vim.log.levels.ERROR
    )
    return
end

