---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc? string
---@param other_opts? vim.keymap.set.Opts
keymap = function(mode, lhs, rhs, desc, other_opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', { silent = true, desc = desc }, other_opts or {}))
end

keymap('i', '<C-c>', '<Esc>')
keymap('n', '<C-c>', ':nohl<CR>')
keymap('n', '==', 'gg<S-v>G')

keymap('n', '<leader>re', '<cmd>restart<cr>', 'restart nvim')

keymap('v', 'p', '"_dP', 'Paste selection without losing yanked text')
keymap('n', '<leader>dl', '"_dd', 'Delete line without yanking')
keymap('v', '<leader>dl', '"_d', 'Delete selection without yanking')

keymap('n', 'J', function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd 'normal! J'
    vim.api.nvim_win_set_cursor(0, pos)
end, 'Join lines without moving cursor')

keymap('n', '<leader>sb', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], 'Replace word on cursor globally')

-- indent
keymap('v', '<', '<gv', 'Unindent and keep selection')
keymap('v', '>', '>gv', 'Indent and keep selection')

-- navigation on insert
keymap('i', '<A-l>', '<Right>', 'Move right in insert mode')
keymap('i', '<A-h>', '<Left>', 'Move left in insert mode')
keymap('i', '<A-b>', '<C-o>b', 'Move back a word')
keymap('i', '<A-w>', '<C-o>w', 'Move forward a word')

-- better line start/end
keymap('n', '<A-h>', '^', 'Go to start of line')
keymap('n', '<A-l>', '$', 'Go to end of line')

-- buffer switching
keymap('n', '<Tab>', ':bnext<CR>', 'Next buffer')
keymap('n', '<S-Tab>', ':bprevious<CR>', 'Previous buffer')

-- quick switch to last edited file
keymap('n', '<leader>bb', '<cmd>e #<cr>', 'Switch to Other Buffer')
keymap('n', '<leader>`', '<cmd>e #<cr>', 'Switch to Other Buffer')

-- move current line up/down
keymap('n', '<A-j>', ':m .+1<CR>==')
keymap('n', '<A-k>', ':m .-2<CR>==')
keymap('v', '<A-j>', ":m '>+1<CR>gv=gv")
keymap('v', '<A-k>', ":m '<-2<CR>gv=gv")

keymap('n', '<leader>u', function()
    vim.cmd.packadd 'nvim.undotree'
    require('undotree').open()
end, 'Toggle builtin undotree')

-- spellcheck
keymap('n', '<leader>sp', ':setlocal spell!<CR>', 'Toggle Spellcheck')
keymap('n', '<leader>zz', 'z=', 'Suggest Corrections')
