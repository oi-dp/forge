vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }

require('gitsigns').setup {
    signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
    },
    signs_staged = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
    },
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    preview_config = { border = 'rounded' },
    gh = true,
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        vim.b[bufnr].miniclue_config = {
            clues = {
                { mode = 'n', keys = '<leader>g', desc = '+git' },
                { mode = 'x', keys = '<leader>g', desc = '+git' },
            },
        }
        ---@param lhs string
        ---@param rhs function
        ---@param desc string
        local function gsmap(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { desc = desc, buffer = bufnr })
        end
        gsmap('[g', gs.prev_hunk, 'Previous hunk')
        gsmap(']g', gs.prev_hunk, 'Next hunk')
        gsmap('<leader>gR', gs.reset_buffer, 'Reset buffer')
        gsmap('<leader>gb', gs.blame_line, 'Blame line')
        gsmap('<leader>gp', gs.preview_hunk, 'Preview hunk')
        gsmap('<leader>gr', gs.reset_hunk, 'Reset hunk')
        gsmap('<leader>gs', gs.stage_hunk, 'Stage hunk')
    end,
}
