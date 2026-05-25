vim.pack.add {
    { src = 'https://github.com/bluz71/vim-moonfly-colors', name = 'moonfly' },
}

local group = vim.api.nvim_create_augroup('custom_highlight', {})
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = 'moonfly',
    group = group,
    callback = function()
        vim.api.nvim_set_hl(0, 'Function', { fg = '#74b2ff', bold = true })
    end,
})

vim.g.moonflyCursorColor = true
vim.g.moonflyNormalFloat = true
vim.g.moonflyNormalPmenu = true
vim.o.pumborder = 'single'
vim.o.winborder = 'single'

vim.cmd.colorscheme 'moonfly'
