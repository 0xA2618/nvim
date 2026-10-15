require("bufferline").setup {
    options = {
        mode = "buffers",
        themable = true,
        style_preset = require("bufferline").style_preset.default,
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "thin",
        always_show_bufferline = true,
        indicator = {
            style = "underline",
        },
        offsets = {
            {
                filetype = "NvimTree",
                text = "EXPLORER",
                highlight = "Directory",
                text_align = "left",
                separator = true,
            },
        },
    },
}
