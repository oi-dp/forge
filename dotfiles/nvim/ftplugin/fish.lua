-- npm i -g fish-lsp

vim.lsp.config('fish_lsp', {
    cmd = { 'fish-lsp', 'start' },
    filetypes = { 'fish' },
    root_markers = { 'config.fish' },
})
vim.lsp.enable 'fish_lsp'
