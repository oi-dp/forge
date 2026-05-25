vim.pack.add { 'https://github.com/nvim-telescope/telescope.nvim' }

local telescope = require 'telescope'
local builtin = require 'telescope.builtin'

telescope.setup {
    defaults = {
        file_ignore_patterns = { '%.git' },
    },
}

-- keymaps
keymap('n', '<leader>ff', builtin.find_files, 'Telescope find files')
keymap('n', '<leader>fg', builtin.live_grep, 'Telescope live grep')
keymap('n', '<leader>fb', builtin.buffers, 'Telescope buffers')
keymap('n', '<leader>fh', builtin.help_tags, 'Telescope help tags')
keymap('n', '<leader>fa', function()
    builtin.find_files {
        hidden = true,
        no_ignore = true,
    }
end, 'Find All Files (including hidden)')
