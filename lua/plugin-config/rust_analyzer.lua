local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
})
vim.lsp.enable("rust_analyzer")
