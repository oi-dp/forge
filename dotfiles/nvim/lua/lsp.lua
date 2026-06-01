local palette = {
    err = '#ff5454',
    warn = '#e3c78a',
    info = '#80a0ff',
    hint = '#8cc85f',
}

-- Diagnostics
vim.api.nvim_set_hl(0, 'DiagnosticErrorLine', { bg = palette.err, blend = 20 })
vim.api.nvim_set_hl(0, 'DiagnosticWarnLine', { bg = palette.warn, blend = 15 })
vim.api.nvim_set_hl(0, 'DiagnosticInfoLine', { bg = palette.info, blend = 10 })
vim.api.nvim_set_hl(0, 'DiagnosticHintLine', { bg = palette.hint, blend = 10 })

vim.api.nvim_set_hl(0, 'DapBreakpointSign', { fg = '#FF5454', bg = nil, bold = true })
vim.fn.sign_define('DapBreakpoint', {
    text = '● ',
    texthl = 'DapBreakpointSign',
    linehl = '',
    numhl = '',
})

-- local sev = vim.diagnostic.severity

vim.diagnostic.config {
    underline = true,
    severity_sort = true,
    update_in_insert = false, -- Less flicker
    float = {
        border = 'rounded',
        max_height = 20,
        max_width = 80,
        source = true,
    },
    signs = false,
    -- too noisy with tiny-inline plugin enabled
    -- signs = {
    --     text = {
    --         [sev.ERROR] = ' ',
    --         [sev.WARN] = ' ',
    --         [sev.INFO] = ' ',
    --         [sev.HINT] = ' ',
    --     },
    -- },
}

-- Navigation helpers
local diagnostic_goto = function(next, severity)
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        vim.diagnostic.jump { count = next and 1 or -1, float = true, severity = severity }
    end
end

-- Keymaps
keymap('n', '<leader>ld', vim.diagnostic.open_float, 'Line Diagnostics')
keymap('n', ']d', diagnostic_goto(true), 'Next Diagnostic')
keymap('n', '[d', diagnostic_goto(false), 'Prev Diagnostic')
keymap('n', ']e', diagnostic_goto(true, 'ERROR'), 'Next Error')
keymap('n', '[e', diagnostic_goto(false, 'ERROR'), 'Prev Error')
keymap('n', ']w', diagnostic_goto(true, 'WARN'), 'Next Warning')
keymap('n', '[w', diagnostic_goto(false, 'WARN'), 'Prev Warning')

-- Detach LSP if its waybar
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local filepath = vim.api.nvim_buf_get_name(args.buf)

        -- check if the server is cssls and the file is the waybar stylesheet
        if client and client.name == 'cssls' and filepath:match 'waybar/style%.css' then
            vim.lsp.buf_detach_client(args.buf, client.id)
        end
    end,
})

-- hotkeys
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('ignite_attach', { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        -- local helper
        local function lsp_map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = 'LSP:' .. desc })
        end
        -- Standard mapping
        lsp_map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
        lsp_map('n', 'gr', vim.lsp.buf.references, 'Go to references')
        lsp_map('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
        lsp_map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename Symbol')
        lsp_map('n', '<leader>ca', vim.lsp.buf.code_action, 'Execute Code Action')
    end,
})
