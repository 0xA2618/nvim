require'nvim-treesitter.configs'.setup {
    ensure_installed = { "python", "go", "javascript", "typescript", "html", "css", "lua" },
    highlight = { enable = true },
    indent = { enable = true },
}
