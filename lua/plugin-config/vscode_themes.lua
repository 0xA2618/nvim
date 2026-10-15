local M = {}

local vscode = require('vscode')

function M.apply(style_or_name)
    local target = style_or_name or "dark"

    if target == "gruvbox" then
        vim.cmd("colorscheme gruvbox")
        return
    end

    if target:find("light") or target == "vs-light" or target == "Light 2026" or target == "Light Modern" or target == "Light+" or target == "Visual Studio Light" then
        vscode.setup({ style = "light" })
        vscode.load("light")
    else
        vscode.setup({ style = "dark" })
        vscode.load("dark")
    end

    local cs_mod = package.loaded["colorscheme"]
    if type(cs_mod) == "table" and cs_mod.sync_all_themes then
        cs_mod.sync_all_themes()
    end
end

M.themes = {
    { id = "Light 2026", type = "vscode_light", name = "VS Code Light 2026 (当前VSCode默认)" },
    { id = "Dark 2026", type = "vscode_dark", name = "VS Code Dark 2026 (深色官方)" },
    { id = "Dark+", type = "vscode_dark", name = "VS Code Dark+ (经典深色)" },
    { id = "Dark Modern", type = "vscode_dark", name = "VS Code Dark Modern" },
    { id = "Light+", type = "vscode_light", name = "VS Code Light+ (经典浅色)" },
    { id = "Light Modern", type = "vscode_light", name = "VS Code Light Modern" },
    { id = "Visual Studio Dark", type = "vscode_dark", name = "Visual Studio Dark" },
    { id = "Visual Studio Light", type = "vscode_light", name = "Visual Studio Light" },
    { id = "gruvbox", type = "gruvbox", name = "Gruvbox (保留经典复古暖色)" },
}

return M
