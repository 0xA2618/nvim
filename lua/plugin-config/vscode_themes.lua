local M = {}

local vscode = require('vscode')

function M.apply(style_or_name)
    local target = style_or_name or "dark"

    if target == "gruvbox" or target == "gruvbox-dark" then
        vim.o.background = "dark"
        pcall(vim.cmd, "colorscheme gruvbox")
    elseif target == "gruvbox-light" then
        vim.o.background = "light"
        pcall(vim.cmd, "colorscheme gruvbox")
    elseif target:find("light") or target == "vs-light" or target == "Light 2026" or target == "Light Modern" or target == "Light+" or target == "Visual Studio Light" then
        vim.o.background = "light"
        vscode.setup({ style = "light" })
        vscode.load("light")
    else
        vim.o.background = "dark"
        vscode.setup({ style = "dark" })
        vscode.load("dark")
    end

    local cs_mod = package.loaded["colorscheme"]
    if type(cs_mod) == "table" and cs_mod.sync_all_themes then
        cs_mod.sync_all_themes()
    end
end

M.themes = {
    { id = "gruvbox", type = "gruvbox", name = "Gruvbox Dark (经典暗黑暖调 - 默认推荐)" },
    { id = "Dark 2026", type = "vscode_dark", name = "VS Code Dark 2026 (深色官方)" },
    { id = "Dark+", type = "vscode_dark", name = "VS Code Dark+ (经典深色)" },
    { id = "Dark Modern", type = "vscode_dark", name = "VS Code Dark Modern" },
    { id = "Light 2026", type = "vscode_light", name = "VS Code Light 2026 (官方浅色白底)" },
    { id = "Light+", type = "vscode_light", name = "VS Code Light+ (经典浅色)" },
    { id = "Light Modern", type = "vscode_light", name = "VS Code Light Modern" },
    { id = "Visual Studio Dark", type = "vscode_dark", name = "Visual Studio Dark" },
    { id = "Visual Studio Light", type = "vscode_light", name = "Visual Studio Light" },
    { id = "gruvbox-light", type = "gruvbox_light", name = "Gruvbox Light (复古浅色羊皮纸)" },
}

return M
