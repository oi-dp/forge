-- install with: npm i -g pyright
-- install with: uv add ruff

vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyrightconfig.json', 'pyproject.toml' },
    settings = {
        python = {
            analysis = {
                autosearch = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
    },
})
vim.lsp.enable 'pyright'
