vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
    bigfile = { enabled = true },
    indent = { enabled = true },
    input = {
        enabled = true,
        win = {
            border = true,
            position = 'float',
            enter = true,
        },
    },
    picker = {
        enabled = true,
        actions = {
            opencode_send = function(...)
                return require('opencode').snacks_picker_send(...)
            end,
        },
    },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = {
        enabled = true,
        win = {
            border = true,
            position = 'float',
        },
    },
}
