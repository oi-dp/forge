-- install with rustup toolchain install

vim.lsp.config('rust_analyzer', {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json' },
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = true,
            check = { command = 'clippy' },
            cargo = { allFeatures = true },
        },
    },
})
vim.lsp.enable 'rust_analyzer'
