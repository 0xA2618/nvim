-- lsp/setup.lua

local lspconfig = require("lspconfig")

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright", "gopls", "ts_ls", "html", "cssls", "jsonls", "yamlls", "lua_ls"
    },
    automatic_installation = true,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
end

local servers = {
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

for server, config in pairs(servers) do
    local merged = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        on_attach = on_attach,
    }, config or {})
    if vim.lsp and vim.lsp.config and vim.lsp.enable then
        vim.lsp.config[server] = merged
        vim.lsp.enable(server)
    else
        lspconfig[server].setup(merged)
    end
end


