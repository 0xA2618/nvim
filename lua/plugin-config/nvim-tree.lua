local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')

    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set('n', 'M', function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == "file" and node.name:match("%.md$") then
            require("plugin-config.markdown").choose_open_mode(node.absolute_path)
        else
            api.node.open.edit()
        end
    end, { buffer = bufnr, noremap = true, silent = true, desc = "Choose markdown open mode" })

    vim.keymap.set('n', 'yyp', function()
        local node = api.tree.get_node_under_cursor()
        if node and node.absolute_path then
            local path = node.absolute_path
            vim.fn.setreg('+', path)
            vim.fn.setreg('"', path)
            vim.api.nvim_echo({{ "Copied: " .. path, "Directory" }}, false, {})
        end
    end, { buffer = bufnr, noremap = true, silent = true, desc = "Copy file/folder path" })
end

require('nvim-tree').setup({
    on_attach = my_on_attach,
    view = {
        width = 30,
        side = 'left',
        preserve_window_proportions = true,
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
