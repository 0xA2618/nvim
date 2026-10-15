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

local function sync_markdown_padding()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if normal and normal.bg then
        vim.api.nvim_set_hl(0, "RenderMarkdownPadding", { bg = normal.bg })
    end
end
sync_markdown_padding()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = sync_markdown_padding,
})

