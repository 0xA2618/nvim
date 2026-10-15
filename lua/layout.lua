local M = {}

local opencode_buf = nil

local function find_opencode_cmd()
    local direct_path = "/Users/Yang/.opencode/bin/opencode"
    local bin = "opencode"
    if vim.fn.executable(direct_path) == 1 then
        bin = direct_path
    elseif vim.fn.executable("opencode") ~= 1 then
        return vim.o.shell
    end
    return bin .. " --mini"
end

local function find_tree_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "NvimTree" then
            return win
        end
    end
    return nil
end

local function find_opencode_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
        local bufname = vim.api.nvim_buf_get_name(buf)
        if buftype == "terminal" and bufname:find("opencode") then
            return win
        end
    end
    return nil
end

local function find_main_editor_win()
    local tree_win = find_tree_win()
    local term_win = find_opencode_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= tree_win and win ~= term_win then
            return win
        end
    end
    return nil
end

local function adjust_sizes(tree_win, term_win)
    if tree_win and vim.api.nvim_win_is_valid(tree_win) then
        local target_width = 30
        pcall(vim.api.nvim_win_set_width, tree_win, target_width)
    end

    if term_win and vim.api.nvim_win_is_valid(term_win) then
        local total_lines = vim.o.lines
        local target_height = math.floor(total_lines * 0.32)
        if target_height < 8 then
            target_height = 8
        end
        pcall(vim.api.nvim_win_set_height, term_win, target_height)
    end
end

function M.setup_layout()
    local api = require("nvim-tree.api")

    local initial_wins = vim.api.nvim_tabpage_list_wins(0)
    local is_single_dir_win = false
    if #initial_wins == 1 then
        local buf = vim.api.nvim_win_get_buf(initial_wins[1])
        local bufname = vim.api.nvim_buf_get_name(buf)
        if vim.bo[buf].filetype == "NvimTree" or vim.fn.isdirectory(bufname) == 1 then
            is_single_dir_win = true
        end
    end

    if is_single_dir_win then
        vim.cmd("vsplit")
        vim.cmd("enew")
        vim.cmd("wincmd h")
    end

    if not api.tree.is_visible() then
        api.tree.open()
    end

    local tree_win = find_tree_win()
    if tree_win and vim.api.nvim_win_is_valid(tree_win) then
        vim.api.nvim_set_current_win(tree_win)
        vim.cmd("wincmd H")
    end

    local main_win = find_main_editor_win()
    if not main_win then
        vim.cmd("wincmd l")
        main_win = vim.api.nvim_get_current_win()
    else
        vim.api.nvim_set_current_win(main_win)
    end

    local term_win = find_opencode_win()
    if not term_win then
        vim.api.nvim_set_current_win(main_win)
        vim.cmd("belowright split")
        term_win = vim.api.nvim_get_current_win()

        if opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
            vim.api.nvim_win_set_buf(term_win, opencode_buf)
        else
            opencode_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_win_set_buf(term_win, opencode_buf)
            local opencode_cmd = find_opencode_cmd()
            vim.fn.termopen(opencode_cmd)
            vim.bo[opencode_buf].buflisted = false
        end
        vim.wo[term_win].winhighlight = "Normal:Normal,NormalNC:NormalNC,SignColumn:Normal"
    end

    adjust_sizes(tree_win, term_win)

    if is_single_dir_win and tree_win and vim.api.nvim_win_is_valid(tree_win) then
        vim.api.nvim_set_current_win(tree_win)
        local line_count = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(tree_win))
        local target_line = line_count >= 2 and 2 or 1
        pcall(vim.api.nvim_win_set_cursor, tree_win, { target_line, 0 })
    elseif main_win and vim.api.nvim_win_is_valid(main_win) then
        vim.api.nvim_set_current_win(main_win)
    end
end

function M.toggle_opencode()
    local term_win = find_opencode_win()
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_close(term_win, true)
        local main_win = find_main_editor_win()
        if main_win then
            vim.api.nvim_set_current_win(main_win)
        end
        return
    end

    local main_win = find_main_editor_win()
    if not main_win then
        M.setup_layout()
        return
    end

    vim.api.nvim_set_current_win(main_win)
    vim.cmd("belowright split")
    local new_term_win = vim.api.nvim_get_current_win()

    if opencode_buf and vim.api.nvim_buf_is_valid(opencode_buf) then
        vim.api.nvim_win_set_buf(new_term_win, opencode_buf)
    else
        opencode_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(new_term_win, opencode_buf)
        local opencode_cmd = find_opencode_cmd()
        vim.fn.termopen(opencode_cmd)
        vim.bo[opencode_buf].buflisted = false
    end

    local tree_win = find_tree_win()
    adjust_sizes(tree_win, new_term_win)

    vim.api.nvim_set_current_win(new_term_win)
    vim.cmd("startinsert")
end

function M.smart_close_buffer()
    local cur_win = vim.api.nvim_get_current_win()
    local cur_buf = vim.api.nvim_get_current_buf()

    local buftype = vim.bo[cur_buf].buftype
    local filetype = vim.bo[cur_buf].filetype

    if filetype == "NvimTree" then
        return
    end

    if buftype == "terminal" then
        M.toggle_opencode()
        return
    end

    local listed_bufs = vim.fn.getbufinfo({ buflisted = 1 })
    local valid_bufs = {}
    for _, b in ipairs(listed_bufs) do
        if b.bufnr ~= cur_buf and vim.bo[b.bufnr].buftype == "" then
            table.insert(valid_bufs, b.bufnr)
        end
    end

    if #valid_bufs > 0 then
        vim.cmd("Bdelete!")
    else
        vim.cmd("enew")
        pcall(vim.api.nvim_buf_delete, cur_buf, { force = true })
    end

    local tree_win = find_tree_win()
    local term_win = find_opencode_win()
    adjust_sizes(tree_win, term_win)
end

vim.api.nvim_create_user_command("SmartCloseBuffer", function()
    M.smart_close_buffer()
end, {})

vim.api.nvim_create_user_command("DevLayout", function()
    M.setup_layout()
end, {})

vim.api.nvim_create_user_command("OpenCodeToggle", function()
    M.toggle_opencode()
end, {})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() > 0 then
            local first_arg = vim.fn.argv(0)
            if first_arg:match("COMMIT_EDITMSG") or first_arg:match("MERGE_MSG") then
                return
            end
        end
        vim.schedule(function()
            M.setup_layout()
        end)
    end,
})

return M
