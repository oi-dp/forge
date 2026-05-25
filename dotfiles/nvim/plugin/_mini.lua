vim.pack.add { 'https://github.com/echasnovski/mini.nvim' }

-- mini modules
require('mini.surround').setup()
require('mini.comment').setup {
    options = {},
    mappings = {
        commnent = 'gc',
        comment_line = 'gcc',
        comment_visual = 'gc',
        text_object = 'gc',
    },
}

require('mini.notify').setup {
    content = {
        format = function(notif)
            return notif.msg
        end,
    },
}

local custom_clues = require('lib.clues').clues
local mini_clue = require 'mini.clue'

mini_clue.setup {
    clues = {
        custom_clues,
        mini_clue.gen_clues.builtin_completion(),
        mini_clue.gen_clues.g(),
        mini_clue.gen_clues.marks(),
        mini_clue.gen_clues.registers(),
        mini_clue.gen_clues.square_brackets(),
        mini_clue.gen_clues.windows { submode_resize = true },
    },
    triggers = {
        { mode = { 'n', 'x' }, keys = '<Leader>' },
        { mode = { 'n', 'x' }, keys = '<localleader>' },
        { mode = { 'n', 'x' }, keys = '[' },
        { mode = { 'n', 'x' }, keys = ']' },
        { mode = 'i', keys = '<C-x>' },
        { mode = { 'n', 'x' }, keys = 'g' },
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = '`' },
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = { 'n', 'x' }, keys = 's' },
        { mode = { 'n', 'x' }, keys = 'z' },
    },
    window = {
        config = {
            width = 70,
            anchor = 'SE',
            row = 'auto',
            col = 'auto',
        },
        delay = 500,
        scroll_up = '<C-k>',
        scroll_down = '<C-j>',
    },
}

local hipatterns = require 'mini.hipatterns'
hipatterns.setup {
    highlighters = {
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
}
