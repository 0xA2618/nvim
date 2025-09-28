-- plugin-config/dashboard.lua
local status, db = pcall(require, "dashboard")
if not status then
    vim.notify("dashboard.nvim not found!")
    return
end

db.setup({
    theme = 'doom', -- 主题: doom / hyper
    config = {
        header = {
            '███╗   ██╗██╗   ██╗██╗███╗   ███╗',
            '████╗  ██║██║   ██║██║████╗ ████║',
            '██╔██╗ ██║██║   ██║██║██╔████╔██║',
            '██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║',
            '██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║',
            '╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
        },
        center = {
            {
                icon = '  ',
                desc = 'Recently opened files              ',
                action = 'Telescope oldfiles',
                shortcut = 'SPC f r'
            },
            {
                icon = '  ',
                desc = 'Find File                          ',
                action = 'Telescope find_files',
                shortcut = 'SPC f f'
            },
            {
                icon = '  ',
                desc = 'File Browser                       ',
                action = 'NvimTreeToggle',
                shortcut = 'SPC e'
            },
            {
                icon = '  ',
                desc = 'Find word                          ',
                action = 'Telescope live_grep',
                shortcut = 'SPC f g'
            },
            {
                icon = '  ',
                desc = 'Open init.lua                      ',
                action = 'edit ~/.config/nvim/init.lua',
                shortcut = 'SPC f d'
            },
        },
        footer = { "Happy coding with Neovim ❤️" }
    },
})
