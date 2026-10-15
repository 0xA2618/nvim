-- colorscheme.lua

local ok_vsc, vsc_themes = pcall(require, "plugin-config.vscode_themes")

if ok_vsc then
    vsc_themes.apply("Light 2026")
else
    local ok, _ = pcall(vim.cmd, "colorscheme vscode")
    if not ok then
        pcall(vim.cmd, "colorscheme gruvbox")
    end
end

local function sync_all_themes()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if normal and normal.bg then
        vim.api.nvim_set_hl(0, "RenderMarkdownPadding", { bg = normal.bg })
        vim.api.nvim_set_hl(0, "Terminal", { bg = normal.bg, fg = normal.fg })
    end

    local term_bg = normal and normal.bg and string.format("#%06x", normal.bg) or "#1e1e1e"
    vim.g.terminal_color_background = term_bg

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bt = vim.bo[buf].buftype
        if bt == "terminal" then
            vim.wo[win].winhighlight = "Normal:Normal,NormalNC:NormalNC,SignColumn:Normal"
        end
    end
end

sync_all_themes()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = sync_all_themes,
})

local M = {}
M.sync_all_themes = sync_all_themes
return M
