vim.pack.add {
    {
        src = 'https://github.com/saghen/blink.cmp.git',
        version = vim.version.range '1.*',
    },
}

local has_blink, blink = pcall(require, 'blink.cmp')
if has_blink then
    local has_luasnip, luasnip_loader = pcall(require, 'luasnip.loaders.from_vscode')
    if has_luasnip then
        luasnip_loader.lazy_load {
            paths = { vim.fn.stdpath 'config' .. '/snippets' },
        }
    end

    blink.setup {
        keymap = {
            preset = 'default',
            ['<CR>'] = { 'accept', 'fallback' },
            ['<C-space>'] = { 'show' },
        },
        appearance = { nerd_font_variant = 'mono' },
        completion = {
            documentation = { auto_show = true },
        },
        snippets = { preset = 'luasnip' },
        cmdline = { enabled = false },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
    }
    vim.lsp.config('*', { capabilities = blink.get_lsp_capabilities(nil, true) })
end
