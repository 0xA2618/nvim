local M = {}

local function run_filter_command(cmd)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local input_text = table.concat(lines, "\n")
    local output = vim.fn.system(cmd, input_text)
    if vim.v.shell_error == 0 and output and output ~= "" then
        local new_lines = vim.split(output, "\n")
        if new_lines[#new_lines] == "" then
            table.remove(new_lines, #new_lines)
        end
        local view = vim.fn.winsaveview()
        vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
        vim.fn.winrestview(view)
        return true
    end
    return false
end

function M.format_buffer()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true

    local ft = vim.bo.filetype

    if ft == "json" or ft == "jsonc" then
        if vim.fn.executable("jq") == 1 then
            if run_filter_command("jq --indent 4 .") then
                vim.notify("Formatted JSON (jq, 4 spaces)", vim.log.levels.INFO)
                return
            end
        end
        if run_filter_command("python3 -m json.tool --indent 4") then
            vim.notify("Formatted JSON (python3, 4 spaces)", vim.log.levels.INFO)
            return
        end
    elseif ft == "sql" or ft == "mysql" then
        local sql_cfg = vim.fn.shellescape('{"tabWidth": 4, "useTabs": false, "keywordCase": "upper"}')
        local cmd = "npx --yes sql-formatter -l mysql --config " .. sql_cfg
        if run_filter_command(cmd) then
            vim.notify("Formatted SQL/MySQL (sql-formatter, 4 spaces)", vim.log.levels.INFO)
            return
        end
    elseif ft == "yaml" or ft == "yml" then
        local cmd = "npx --yes prettier --parser yaml --tab-width 4"
        if run_filter_command(cmd) then
            vim.notify("Formatted YAML (prettier, 4 spaces)", vim.log.levels.INFO)
            return
        end
    end

    local has_lsp = false
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
        if client.supports_method("textDocument/formatting") then
            has_lsp = true
            break
        end
    end

    if has_lsp then
        vim.lsp.buf.format({
            async = false,
            formatting_options = {
                tabSize = 4,
                insertSpaces = true,
            },
        })
        vim.notify("Formatted code via LSP (4 spaces)", vim.log.levels.INFO)
    else
        local view = vim.fn.winsaveview()
        vim.cmd("normal! gg=G")
        vim.fn.winrestview(view)
        vim.notify("Formatted code via Neovim indentation (4 spaces)", vim.log.levels.INFO)
    end
end

return M
