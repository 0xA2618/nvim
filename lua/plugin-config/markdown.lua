local M = {}

vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_command_for_global = 0
vim.g.mkdp_open_to_the_world = 0
vim.g.mkdp_open_ip = ""
vim.g.mkdp_browser = ""
vim.g.mkdp_echo_preview_url = 0
vim.g.mkdp_browserfunc = ""
vim.g.mkdp_page_title = "${name}"
vim.g.mkdp_theme = "dark"

local custom_css = vim.fn.expand("~/.config/nvim/lua/plugin-config/markdown_toc.css")
if vim.fn.filereadable(custom_css) == 1 then
    vim.g.mkdp_markdown_css = custom_css
end

local render_config = {
    enabled = true,
    render_modes = { "n", "c", "t" },
    anti_conceal = {
        enabled = true,
    },
    heading = {
        enabled = true,
        sign = true,
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
        width = "block",
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        backgrounds = {
            "RenderMarkdownH1Bg",
            "RenderMarkdownH2Bg",
            "RenderMarkdownH3Bg",
            "RenderMarkdownH4Bg",
            "RenderMarkdownH5Bg",
            "RenderMarkdownH6Bg",
        },
    },
    code = {
        enabled = true,
        sign = true,
        style = "full",
        border = "thick",
    },
    bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
    },
    checkbox = {
        enabled = true,
    },
    table = {
        enabled = true,
        style = "full",
        cell = "padded",
    },
    callout = {
        note = { raw = "[!NOTE]", rendered = "Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = "Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "Caution", highlight = "RenderMarkdownError" },
    },
}

vim.g.render_markdown_config = render_config

local ok_rm, render_markdown = pcall(require, "render-markdown")
if ok_rm then
    render_markdown.setup(render_config)
end

local function open_markmap(filepath)
    if not filepath or filepath == "" then
        filepath = vim.api.nvim_buf_get_name(0)
    end
    if not filepath or filepath == "" then
        vim.notify("未找到可供 Markmap 预览的文件", vim.log.levels.WARN)
        return
    end

    local tmp_dir = vim.fn.tempname()
    vim.fn.mkdir(tmp_dir, "p")
    local filename = vim.fn.fnamemodify(filepath, ":t:r")
    local tmp_output = tmp_dir .. "/" .. filename .. ".html"

    vim.fn.jobstart({ "npx", "markmap-cli", filepath, "-o", tmp_output }, {
        detach = true,
        on_start = function()
            vim.notify("正在启动 Markmap 思维导图: " .. vim.fn.fnamemodify(filepath, ":t"), vim.log.levels.INFO)
        end,
    })
end

local function set_in_buffer_render(enable)
    local ok, rm = pcall(require, "render-markdown")
    if ok then
        if enable then
            rm.enable()
            vim.opt_local.conceallevel = 2
            vim.opt_local.concealcursor = ""
        else
            rm.disable()
            vim.opt_local.conceallevel = 0
            vim.opt_local.concealcursor = ""
        end
    end
end

local function open_browser_preview(filepath)
    if not filepath or filepath == "" then
        filepath = vim.api.nvim_buf_get_name(0)
    end
    if not filepath or filepath == "" then
        vim.notify("未找到可供预览的文件", vim.log.levels.WARN)
        return
    end

    local server_script = vim.fn.expand("~/.config/nvim/lua/plugin-config/browser_preview.js")
    vim.fn.jobstart({ "node", server_script, filepath }, {
        detach = true,
        on_start = function()
            vim.notify("正在启动浏览器预览 (含左侧折叠大纲): " .. vim.fn.fnamemodify(filepath, ":t"), vim.log.levels.INFO)
        end,
    })
end

local function execute_choice(idx, target_path)
    local filename = vim.fn.fnamemodify(target_path, ":t")

    local target_win = nil
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(w)
        local ft = vim.bo[buf].filetype
        local bt = vim.bo[buf].buftype
        if ft ~= "NvimTree" and bt ~= "terminal" then
            target_win = w
            break
        end
    end

    if target_win and vim.api.nvim_win_is_valid(target_win) then
        vim.api.nvim_set_current_win(target_win)
    end

    if target_path and target_path ~= "" then
        vim.cmd("edit " .. vim.fn.fnameescape(target_path))
    end

    if idx == 1 then
        set_in_buffer_render(true)
        vim.notify("已在 Buffer 中启用 Markdown Preview Enhanced: " .. filename, vim.log.levels.INFO)
    elseif idx == 2 then
        vim.schedule(function()
            open_markmap(target_path)
        end)
    elseif idx == 3 then
        vim.schedule(function()
            open_browser_preview(target_path)
        end)
    end
end

function M.choose_open_mode(filepath)
    local target_path = filepath
    if not target_path or target_path == "" then
        target_path = vim.api.nvim_buf_get_name(0)
    end

    local filename = vim.fn.fnamemodify(target_path, ":t")
    local lines = {
        "  1. Markdown Preview Enhanced",
        "  2. Markmap",
        "  3. Browser",
    }

    local max_len = 0
    for _, line in ipairs(lines) do
        local len = vim.fn.strdisplaywidth(line)
        if len > max_len then
            max_len = len
        end
    end

    local width = max_len + 4
    local height = #lines
    local total_lines = vim.o.lines
    local total_cols = vim.o.columns
    local row = math.floor((total_lines - height) / 2)
    local col = math.floor((total_cols - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].filetype = "markdown-chooser"

    local title = " 打开方式: " .. filename .. " "
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = title,
        title_pos = "center",
    })

    vim.wo[win].cursorline = true
    vim.wo[win].wrap = false

    local function close_win()
        if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    local function select_current()
        local cursor = vim.api.nvim_win_get_cursor(win)
        local selected_idx = cursor[1]
        close_win()
        execute_choice(selected_idx, target_path)
    end

    local keymaps = {
        ["<CR>"] = select_current,
        ["<Space>"] = select_current,
        ["q"] = close_win,
        ["<Esc>"] = close_win,
        ["1"] = function()
            close_win()
            execute_choice(1, target_path)
        end,
        ["2"] = function()
            close_win()
            execute_choice(2, target_path)
        end,
        ["3"] = function()
            close_win()
            execute_choice(3, target_path)
        end,
    }

    local opts = { buffer = buf, noremap = true, silent = true }
    for key, fn in pairs(keymaps) do
        vim.keymap.set("n", key, fn, opts)
    end

    vim.keymap.set("n", "j", function()
        local cur = vim.api.nvim_win_get_cursor(win)[1]
        if cur < height then
            vim.api.nvim_win_set_cursor(win, { cur + 1, 0 })
        else
            vim.api.nvim_win_set_cursor(win, { 1, 0 })
        end
    end, opts)

    vim.keymap.set("n", "k", function()
        local cur = vim.api.nvim_win_get_cursor(win)[1]
        if cur > 1 then
            vim.api.nvim_win_set_cursor(win, { cur - 1, 0 })
        else
            vim.api.nvim_win_set_cursor(win, { height, 0 })
        end
    end, opts)
end

function M.toggle_in_buffer_render()
    local ok, rm = pcall(require, "render-markdown")
    if ok then
        rm.toggle()
    end
end

vim.api.nvim_create_user_command("MarkdownChooseMode", function(opts)
    local path = opts.args ~= "" and opts.args or nil
    M.choose_open_mode(path)
end, { nargs = "?" })

vim.api.nvim_create_user_command("MarkdownToggleRender", function()
    M.toggle_in_buffer_render()
end, {})

vim.api.nvim_create_user_command("MarkmapPreview", function()
    open_markmap()
end, {})

return M
