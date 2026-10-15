local function get_lualine_theme()
    if vim.o.background == "light" then
        return {
            normal = {
                a = { fg = "#ffffff", bg = "#007acc", gui = "bold" },
                b = { fg = "#202020", bg = "#e8e8e8" },
                c = { fg = "#333333", bg = "#f3f3f3" },
            },
            insert = {
                a = { fg = "#ffffff", bg = "#008000", gui = "bold" },
                b = { fg = "#202020", bg = "#e8e8e8" },
                c = { fg = "#333333", bg = "#f3f3f3" },
            },
            visual = {
                a = { fg = "#ffffff", bg = "#d16969", gui = "bold" },
                b = { fg = "#202020", bg = "#e8e8e8" },
                c = { fg = "#333333", bg = "#f3f3f3" },
            },
            replace = {
                a = { fg = "#ffffff", bg = "#ad0707", gui = "bold" },
                b = { fg = "#202020", bg = "#e8e8e8" },
                c = { fg = "#333333", bg = "#f3f3f3" },
            },
            command = {
                a = { fg = "#ffffff", bg = "#a626a4", gui = "bold" },
                b = { fg = "#202020", bg = "#e8e8e8" },
                c = { fg = "#333333", bg = "#f3f3f3" },
            },
            inactive = {
                a = { fg = "#777777", bg = "#e8e8e8" },
                b = { fg = "#777777", bg = "#e8e8e8" },
                c = { fg = "#777777", bg = "#f3f3f3" },
            },
        }
    else
        local ok, gruvbox = pcall(require, "lualine.themes.gruvbox")
        if ok and vim.g.colors_name == "gruvbox" then
            return "gruvbox"
        end
        return {
            normal = {
                a = { fg = "#ffffff", bg = "#0e639c", gui = "bold" },
                b = { fg = "#cccccc", bg = "#2d2d2d" },
                c = { fg = "#858585", bg = "#1e1e1e" },
            },
            insert = {
                a = { fg = "#ffffff", bg = "#4ec9b0", gui = "bold" },
                b = { fg = "#cccccc", bg = "#2d2d2d" },
                c = { fg = "#858585", bg = "#1e1e1e" },
            },
            visual = {
                a = { fg = "#ffffff", bg = "#ce9178", gui = "bold" },
                b = { fg = "#cccccc", bg = "#2d2d2d" },
                c = { fg = "#858585", bg = "#1e1e1e" },
            },
            inactive = {
                a = { fg = "#666666", bg = "#252526" },
                b = { fg = "#666666", bg = "#252526" },
                c = { fg = "#666666", bg = "#1e1e1e" },
            },
        }
    end
end

require("lualine").setup {
    options = {
        theme = get_lualine_theme,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
    },
}
