vim.pack.add {
    'https://github.com/nvim-mini/mini.comment',
    'https://github.com/nvim-mini/mini.surround',
    'https://github.com/nvim-mini/mini.hipatterns',
}

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
