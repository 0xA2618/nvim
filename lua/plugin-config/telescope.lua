local M = {}

function M.choose_colorscheme()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    local available_schemes = { "vscode", "gruvbox" }
    for _, name in ipairs(vim.fn.getcompletion("", "color")) do
        if not vim.tbl_contains(available_schemes, name) then
            table.insert(available_schemes, name)
        end
    end

    pickers.new({}, {
        prompt_title = "Select Theme (Enter to apply)",
        finder = finders.new_table({
            results = available_schemes,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection and selection[1] then
                    local scheme = selection[1]
                    local ok = pcall(vim.cmd, "colorscheme " .. scheme)
                    if ok then
                        local cs_mod = package.loaded["colorscheme"]
                        if cs_mod and cs_mod.sync_all_themes then
                            cs_mod.sync_all_themes()
                        end
                        vim.notify("Active Theme: " .. scheme, vim.log.levels.INFO)
                    end
                end
            end)
            return true
        end,
    }):find()
end

function M.command_palette()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    local commands = {
        {
            title = "Window: Reload Window (重新加载窗口 / 重绘恢复)",
            action = function()
                vim.cmd("nohlsearch")
                vim.cmd("diffupdate")
                pcall(vim.cmd, "syntax sync fromstart")
                vim.cmd("mode")
                vim.cmd("redraw!")
                local cs_mod = package.loaded["colorscheme"]
                if cs_mod and cs_mod.sync_all_themes then
                    cs_mod.sync_all_themes()
                end
                vim.notify("Window reloaded successfully", vim.log.levels.INFO)
            end,
        },
        {
            title = "Preferences: Color Theme (切换配色主题)",
            action = function()
                vim.schedule(M.choose_colorscheme)
            end,
        },
        {
            title = "View: Toggle OpenCode (打开/隐藏 AI 对话终端)",
            action = function()
                local layout = package.loaded["layout"]
                if layout and layout.toggle_opencode then
                    layout.toggle_opencode()
                end
            end,
        },
        {
            title = "View: Rebuild DevLayout (一键重建标准三栏工作区)",
            action = function()
                local layout = package.loaded["layout"]
                if layout and layout.setup_layout then
                    layout.setup_layout()
                end
            end,
        },
        {
            title = "File: Save (保存文件)",
            action = function()
                vim.cmd("w")
            end,
        },
        {
            title = "File: Close Buffer (关闭当前标签页)",
            action = function()
                local layout = package.loaded["layout"]
                if layout and layout.smart_close_buffer then
                    layout.smart_close_buffer()
                else
                    vim.cmd("Bdelete!")
                end
            end,
        },
    }

    pickers.new({}, {
        prompt_title = "> Command Palette (Shift+Cmd+P)",
        finder = finders.new_table({
            results = commands,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.title,
                    ordinal = entry.title,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection and selection.value and selection.value.action then
                    selection.value.action()
                end
            end)
            return true
        end,
    }):find()
end

require("telescope").setup {
    defaults = {
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        prompt_prefix = " > ",
        color_devicons = true,
    },
}

vim.api.nvim_create_user_command("VSCodeCommandPalette", function()
    M.command_palette()
end, {})

vim.api.nvim_create_user_command("SelectTheme", function()
    M.choose_colorscheme()
end, {})

return M
