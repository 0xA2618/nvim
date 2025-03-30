local lspconfig = require("lspconfig")

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright",
        "gopls",
        "jsonls",
        "yamlls",
        "lua_ls",
        "bashls",
        "volar", -- vue3
        "ts_ls", -- TypeScript LSP
        "html",
        "cssls"
    }, -- 确保这几个 LSP 服务器安装
})

-- 配置 Python LSP (pyright)
lspconfig.pyright.setup({})

-- 设置 Vue 语言服务器
-- Vue 3 LSP (Volar)
lspconfig.volar.setup({
    filetypes = { "vue" },
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
    settings = {
        volar = {
            document = {
                syntax = { enable = true }
            }
        }
    }
})

-- vue
-- 使用 ts_ls 代替 tsserver
lspconfig.ts_ls.setup({
    filetypes = {
        "typescript",
        "typescriptreact",
        "javascriptreact",
        "vue" },
    root_dir = lspconfig.util.root_pattern(
        "package.json",
        "tsconfig.json",
        ".git"),
})

-- vue
-- ESLint LSP
lspconfig.eslint.setup({
    settings = { format = true },
})

-- 配置 Go LSP (gopls)
lspconfig.gopls.setup({
    settings = {
        gopls = {
            -- 启用静态检查
            staticcheck = true,

            -- 启用代码格式化功能
            formatting = {
                enabled = true, -- 启用格式化
            },

            -- 启用代码补全功能
            completion = {
                enabled = true, -- 启用代码补全
            }
        }
    }
})

-- 配置 JSON LSP (jsonls)
lspconfig.jsonls.setup({})

-- 将补全插件连接到 LSP 服务器
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.pyright.setup({ capabilities = capabilities })
lspconfig.gopls.setup({ capabilities = capabilities })
lspconfig.jsonls.setup({ capabilities = capabilities })
lspconfig.yamlls.setup({ capabilities = capabilities })
lspconfig.lua_ls.setup({ capabilities = capabilities })
lspconfig.bashls.setup({ capabilities = capabilities })
