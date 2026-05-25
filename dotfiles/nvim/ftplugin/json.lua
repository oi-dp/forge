-- npm i -g vscode-langservers-extracted

vim.lsp.config('jsonls', {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    settings = {
        json = {
            validate = { enable = true },
        },
    },
})
vim.lsp.enable 'jsonls'
