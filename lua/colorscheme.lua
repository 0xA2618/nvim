-- colorscheme.lua

local ok_vsc, vsc_themes = pcall(require, "plugin-config.vscode_themes")

if ok_vsc then
    vsc_themes.apply("gruvbox")
else
    vim.o.background = "dark"
    pcall(vim.cmd, "colorscheme gruvbox")
end

local function sync_all_themes()
    local is_light = vim.o.background == "light"
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })

    if is_light then
        vim.api.nvim_set_hl(0, "Normal", { bg = "#ffffff", fg = "#202020" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "#fafafa", fg = "#505050" })
        vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#f3f3f3", fg = "#333333" })
        vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "#f3f3f3", fg = "#555555" })
        vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { fg = "#f3f3f3", bg = "#f3f3f3" })
        vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = "#e4e6f1" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#ffffff", bg = "#ffffff" })
        vim.api.nvim_set_hl(0, "BufferLineOffset", { bg = "#f3f3f3", fg = "#333333", bold = true })
        vim.api.nvim_set_hl(0, "BufferLineOffsetSeparator", { fg = "#d4d4d4", bg = "#f3f3f3" })
        vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "#e8e8e8" })
        vim.api.nvim_set_hl(0, "BufferLineBackground", { bg = "#e8e8e8", fg = "#666666" })
        vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { bg = "#ffffff", fg = "#202020", bold = true })
        vim.api.nvim_set_hl(0, "BufferLineSeparator", { fg = "#d4d4d4", bg = "#e8e8e8" })
        vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = "#d4d4d4", bg = "#ffffff" })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#e0e0e0", bg = "#f3f3f3" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "#ffffff", fg = "#999999" })
        vim.api.nvim_set_hl(0, "FoldColumn", { bg = "#ffffff", fg = "#999999" })
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#999999", bg = "#ffffff" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#007acc", bg = "#f5f5f5", bold = true })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#f8f8f8" })

        vim.api.nvim_set_hl(0, "Terminal", { bg = "#ffffff", fg = "#202020" })
        vim.g.terminal_color_background = "#ffffff"
        vim.g.terminal_color_foreground = "#202020"
        vim.g.terminal_color_0 = "#ffffff"
        vim.g.terminal_color_7 = "#202020"
        vim.g.terminal_color_8 = "#888888"
        vim.g.terminal_color_15 = "#111111"

        vim.api.nvim_set_hl(0, "RenderMarkdownPadding", { bg = "#ffffff" })
    else
        if normal and normal.bg then
            vim.api.nvim_set_hl(0, "RenderMarkdownPadding", { bg = normal.bg })
            vim.api.nvim_set_hl(0, "Terminal", { bg = normal.bg, fg = normal.fg })
        end
        local term_bg = normal and normal.bg and string.format("#%06x", normal.bg) or "#282828"
        vim.g.terminal_color_background = term_bg
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3c3836", bg = "NONE" })
        vim.api.nvim_set_hl(0, "BufferLineOffset", { bg = "#282828", fg = "#a89984", bold = true })
        vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "#1d2021" })
    end

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bt = vim.bo[buf].buftype
        local ft = vim.bo[buf].filetype
        if bt == "terminal" then
            if is_light then
                vim.wo[win].winhighlight = "Normal:Terminal,NormalNC:Terminal,SignColumn:Terminal"
            else
                vim.wo[win].winhighlight = "Normal:Normal,NormalNC:NormalNC,SignColumn:Normal"
            end
        elseif ft == "NvimTree" then
            vim.wo[win].winhighlight = "Normal:NvimTreeNormal,NormalNC:NvimTreeNormalNC,EndOfBuffer:NvimTreeNormal,SignColumn:NvimTreeNormal"
        end
    end

    local ok_lualine, lualine = pcall(require, "lualine")
    if ok_lualine then
        lualine.setup()
    end
end

sync_all_themes()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = sync_all_themes,
})

local M = {}
M.sync_all_themes = sync_all_themes
return M
