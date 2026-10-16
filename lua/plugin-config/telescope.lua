local M = {}

function M.choose_colorscheme()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local vsc_themes = require("plugin-config.vscode_themes")

    local initial_scheme = vim.g.colors_name or "vscode"
    local initial_bg = vim.o.background
    local need_restore = true

    local available_themes = vsc_themes.themes

    local function apply_theme(theme_obj, is_permanent)
        if not theme_obj then return end
        if theme_obj.type == "gruvbox" then
            vim.o.background = "dark"
            pcall(vim.cmd, "colorscheme gruvbox")
        elseif theme_obj.type == "gruvbox_light" then
            vim.o.background = "light"
            pcall(vim.cmd, "colorscheme gruvbox")
        else
            vsc_themes.apply(theme_obj.id, is_permanent)
        end
        local cs_mod = package.loaded["colorscheme"]
        if cs_mod and cs_mod.sync_all_themes then
            cs_mod.sync_all_themes()
        end
    end

    local picker = pickers.new({}, {
        prompt_title = "Theme Picker (j/k 实时预览，回车确认，Esc取消)",
        finder = finders.new_table({
            results = available_themes,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name,
                    ordinal = entry.name .. " " .. entry.id,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local function move_and_preview(direction)
                if direction == "next" then
                    actions.move_selection_next(prompt_bufnr)
                else
                    actions.move_selection_previous(prompt_bufnr)
                end
                local entry = action_state.get_selected_entry()
                if entry and entry.value then
                    apply_theme(entry.value, false)
                end
            end

            map("i", "<C-n>", function() move_and_preview("next") end)
            map("i", "<C-p>", function() move_and_preview("prev") end)
            map("i", "<Down>", function() move_and_preview("next") end)
            map("i", "<Up>", function() move_and_preview("prev") end)
            map("n", "j", function() move_and_preview("next") end)
            map("n", "k", function() move_and_preview("prev") end)

            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                need_restore = false
                actions.close(prompt_bufnr)
                if selection and selection.value then
                    apply_theme(selection.value, true)
                    vim.notify("Active Theme: " .. selection.value.name, vim.log.levels.INFO)
                end
            end)

            actions.close:enhance({
                post = function()
                    if need_restore then
                        vim.o.background = initial_bg
                        pcall(vim.cmd, "colorscheme " .. initial_scheme)
                        local cs_mod = package.loaded["colorscheme"]
                        if cs_mod and cs_mod.sync_all_themes then
                            cs_mod.sync_all_themes()
                        end
                    end
                end,
            })

            return true
        end,
    })

    picker:find()
end

function M.command_palette()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    local commands = {
        {
            title = "Preferences: Color Theme (切换配色主题 - 实时联动)",
            action = function()
                vim.schedule(M.choose_colorscheme)
            end,
        },
        {
            title = "> Window: Reload Window (重新加载窗口 / 重绘恢复)",
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
        prompt_title = "> Command Palette (F1 / Space+p)",
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
