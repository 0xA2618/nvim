-- plugin-config/none-ls.lua
local ok, none_ls = pcall(require, "none-ls")
if not ok then
    return -- 静默返回
end

none_ls.setup({
    debug = false,
    sources = {
        -- Python
        none_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
        none_ls.builtins.diagnostics.flake8,

        -- Go
        none_ls.builtins.formatting.goimports,
        none_ls.builtins.formatting.gofmt,

        -- 前端
        none_ls.builtins.formatting.prettier,
        none_ls.builtins.diagnostics.eslint,

        -- Shell
        none_ls.builtins.formatting.shfmt,
        none_ls.builtins.diagnostics.shellcheck,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = "LspFormatting", buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("LspFormatting", {}),
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,

})
