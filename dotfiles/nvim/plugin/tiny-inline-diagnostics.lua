vim.diagnostic.config {
    -- Disable Neovim's default
    virtual_text = false,
    linehl = false,
}

vim.pack.add { 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' }

require('tiny-inline-diagnostic').setup {
    preset = 'modern',
    transparent_bg = false,
    transparent_cursorline = true,
    hi = {
        error = 'DiagnosticError',
        warn = 'DiagnosticWarn',
        info = 'DiagnosticInfo',
        hint = 'DiagnosticHint',
        arrow = 'NonText',
        background = 'CursorLine',
        mixing_color = 'Normal',
    },
    options = {
        show_source = {
            enabled = false,
            if_many = false,
        },
        throttle = 10,
        softwrap = 40,
        multilines = {
            enabled = true,
            tabstop = 4,
        },
        add_messages = {
            messages = false,
            display_count = true,
        },
        break_line = {
            enabled = true,
            after = 30,
        },
        overflow = {
            mode = 'wrap',
            padding = 0,
        },
        virt_texts = {
            priority = 2048,
        },
    },
}
keymap('n', '<leader>de', '<cmd>TinyInlineDiag enable<cr>', 'Enable diagnostics')
keymap('n', '<leader>dd', '<cmd>TinyInlineDiag disable<cr>', 'Disable diagnostics')
keymap('n', '<leader>dt', '<cmd>TinyInlineDiag toggle<cr>', 'Toggle diagnostics')
keymap('n', '<leader>dc', '<cmd>TinyInlineDiag toggle_cursor_only<cr>', 'Toggle cursor_only diagnostics')
keymap('n', '<leader>dr', '<cmd>TinyInlineDiag reset<cr>', 'Reset diagnostic options')
