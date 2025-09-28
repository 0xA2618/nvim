require("telescope").setup {
    defaults = {
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        prompt_prefix = " > ",
        color_devicons = true,
    },
}
