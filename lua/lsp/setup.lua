-- lsp/setup.lua

-- Mason 安装管理
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright", "gopls", "ts_ls", "html", "cssls", "jsonls", "yamlls", "lua_ls"
    }
})

-- LSP Capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Neovim 0.11+ 推荐使用 vim.lsp.config / vim.lsp.enable
local server_configs = {
    pyright = {},
    gopls = {
        settings = {
            gopls = {
                analyses = { unusedparams = true },
                staticcheck = true,
            },
        },
    },
    ts_ls = {},
    html = {},
    cssls = {},
    jsonls = {},
    yamlls = {},
    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                telemetry = { enable = false },
            },
        },
    },
}

for server, config in pairs(server_configs) do
    local merged = vim.tbl_deep_extend("force", { capabilities = capabilities }, config or {})
    vim.lsp.config(server, merged)
    vim.lsp.enable(server)
end

-- null-ls.nvim 配置
local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    vim.notify("null-ls not found!", vim.log.levels.ERROR)
    return
end

null_ls.setup({
    debug = false,
    sources = {
        null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.diagnostics.shellcheck,
    },
    on_attach = function(client)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = { "*.py", "*.go", "*.js", "*.ts", "*.html", "*.css" },
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    end,
})

