vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

local conform = require 'conform'
conform.setup {
    formatters_by_ft = {
        bash = { 'shfmt' },
        fish = { name = 'fish_lsp', lsp_format = 'prefer' },
        css = { 'prettier' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        lua = { 'stylua' },
        python = { 'ruff', lsp_format = true },
        rust = { 'rustfmt', name = 'rust_analyzer', timeout_ms = 500, lsp_format = 'prefer' },
        sh = { 'shfmt' },
        typescript = { 'prettier' },
        yaml = { 'prettier' },
    },
    formatters = {
        shfmt = { prepend_args = { '-i', '4' } },
        prettier = { require_cwd = true },
    },
    format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
    },
}
