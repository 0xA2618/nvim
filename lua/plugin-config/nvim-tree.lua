local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')

    api.config.mappings.default_on_attach(bufnr)

    local function copy_abs_path()
        local node = api.tree.get_node_under_cursor()
        if node and node.absolute_path then
            local path = node.absolute_path
            vim.fn.setreg('+', path)
            vim.fn.setreg('"', path)
            vim.api.nvim_echo({{ "Copied: " .. path, "Directory" }}, false, {})
        end
    end

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.set('n', 'a', api.fs.create, opts('Create File / Folder'))
    vim.keymap.set('n', 'o', api.node.open.edit, opts('Open File / Toggle Folder'))
    vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
    vim.keymap.set('n', 'yy', api.fs.copy.node, opts('Copy'))
    vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
    vim.keymap.set('n', 'dd', api.fs.remove, opts('Delete'))

    vim.keymap.set('n', 'M', function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == "file" and node.name:match("%.md$") then
            require("plugin-config.markdown").choose_open_mode(node.absolute_path)
        else
            api.node.open.edit()
        end
    end, opts('Choose markdown open mode'))

    vim.keymap.set('n', 'yyp', copy_abs_path, opts('Copy absolute path'))
    vim.keymap.set('n', 'Yyp', copy_abs_path, opts('Copy absolute path'))
    vim.keymap.set('n', 'Y', copy_abs_path, opts('Copy absolute path'))
end

require('nvim-tree').setup({
    on_attach = my_on_attach,
    view = {
        width = 30,
        side = 'left',
        preserve_window_proportions = true,
        signcolumn = "no",
    },
    renderer = {
        icons = {
            glyphs = {
                folder = {
                    arrow_closed = "›",
                    arrow_open = "⌄",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                },
            },
        },
    },
    actions = {
        open_file = {
            quit_on_open = false,
            window_picker = {
                enable = true,
                picker = "default",
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
                    buftype = { "terminal", "help", "nofile" },
                },
            },
        },
    },
})

vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "NvimTree" then
            local ok, api = pcall(require, "nvim-tree.api")
            if ok then
                local node = api.tree.get_node_under_cursor()
                if node and node.absolute_path then
                    vim.api.nvim_echo({{ node.absolute_path, "Comment" }}, false, {})
                end
            end
        end
    end,
})
