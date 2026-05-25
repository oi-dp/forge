-- npm i -g vscode-langservers-extracted

vim.lsp.config('html', {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    embeddedLanguages = { css = true, javascript = true },
})
vim.lsp.config 'html'
