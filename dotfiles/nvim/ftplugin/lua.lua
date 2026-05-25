-- install with: pacman -S lua-language-server
-- install with: pacman -S stylua

vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc' },
    settings = {
        Lua = {
            completion = { callSnippet = 'Replace' },
            format = { enable = false },
            diagnostics = {
                globals = { 'vim' },
            },
            hint = { enable = true },
        },
    },
})
vim.lsp.enable 'lua_ls'
