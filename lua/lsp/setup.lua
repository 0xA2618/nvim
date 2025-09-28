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

-- 保留 require("lspconfig")
local lspconfig = require("lspconfig")

-- Python
lspconfig.pyright.setup({
    capabilities = capabilities,
})

-- Go
lspconfig.gopls.setup({
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
        },
    },
})

-- TypeScript / JavaScript
lspconfig.ts_ls.setup({
    capabilities = capabilities,
})

-- HTML
lspconfig.html.setup({
    capabilities = capabilities,
})

-- CSS
lspconfig.cssls.setup({
    capabilities = capabilities,
})

-- JSON
lspconfig.jsonls.setup({
    capabilities = capabilities,
})

-- YAML
lspconfig.yamlls.setup({
    capabilities = capabilities,
})

-- Lua (Neovim 配置)
lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
        },
    },
})

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

