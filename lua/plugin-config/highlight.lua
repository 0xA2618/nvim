function random_color()
    -- local colors = { "Green", "Blue", "Magenta", "Cyan", "White", "Orange", "Purple", "Pink" }
    local colors = {"#8CCBEA", "#A4E57E", "#FFDB72", "#FF7272", "#FFB3FF", "#9999FF", "#CC8AA2", "#DCC2E5", "#B11E2F"}
    return colors[math.random(#colors)]
end

local highlighted_words = {}

-- 高亮指定字符，并增加不同的背景色
function Highlight_word()
    local word = vim.fn.expand("<cword>")
    if word ~= "" then
        local fg_color = random_color()  -- 前景色
        local bg_color = random_color()  -- 背景色
        local group_name = "WordHighlight" .. word

        -- 创建高亮组，并同时指定前景色和背景色
        vim.cmd(string.format("highlight %s guifg=%s guibg=%s", group_name, fg_color, bg_color))

        -- 匹配并高亮指定单词
        local match_id = vim.fn.matchadd(group_name, "\\<" .. word .. "\\>")
        highlighted_words[word] = { group = group_name, match_id = match_id }
    end
end

function Highlight_word_a()
    local word = vim.fn.expand("<cword>")
    if word ~= "" then
        local color = random_color()
        local group_name = "WordHighlight" .. word
        vim.cmd(string.format("highlight %s guifg=%s", group_name, color))
        local match_id = vim.fn.matchadd(group_name, "\\<" .. word .. "\\>")
        highlighted_words[word] = { group = group_name, match_id = match_id }
    end
end

function Clear_highlight()
    local word = vim.fn.expand("<cword>")
    if highlighted_words[word] then
        vim.fn.matchdelete(highlighted_words[word].match_id)
        vim.cmd("highlight clear " .. highlighted_words[word].group)
        highlighted_words[word] = nil
    end
end

