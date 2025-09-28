local cmp = require("cmp")
local luasnip = require("luasnip")
local npairs = require("nvim-autopairs")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

-- 加载 VSCode 风格 snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- autopairs 配置
npairs.setup({
    check_ts = true,      -- 启用 treesitter 检测括号
    fast_wrap = {},       -- 快速包裹功能
})

-- 让 cmp 与 autopairs 协作
cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })
)

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }),

    formatting = {
        format = function(entry, vim_item)
            local icons = {
                Text = "", Method = "󰆧", Function = "󰊕", Constructor = "",
                Field = "󰇽", Variable = "󰂡", Class = "󰠱", Interface = "",
                Module = "", Property = "󰜢", Unit = "", Value = "󰎠",
                Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
                File = "󰈙", Reference = "󰈇", Folder = "󰉋", Constant = "󰏿",
                Struct = "", Event = "", Operator = "󰆕", TypeParameter = "󰅲",
            }
            vim_item.kind = string.format("%s %s", icons[vim_item.kind] or "", vim_item.kind)
            return vim_item
        end,
    },
})

-- 命令行模式补全
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" }
    }
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" }
    }, {
        { name = "cmdline" }
    })
})

