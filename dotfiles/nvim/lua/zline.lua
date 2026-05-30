local zLine_hl = vim.api.nvim_set_hl

local function zline_hls()
    local ok, moonfly = pcall(require, 'moonfly')
    if not ok then
        return
    end
    local c = moonfly.palette

    local hls = {
        { 'StatusLine', { fg = c.fg, bg = c.grey11 } },
        { 'StatusLineNC', { fg = c.grey236, bg = c.bg0 } },
        { 'Sep', { fg = c.grey236, bg = c.bg0 } },
        -- Modes
        { 'Norm', { fg = c.blue, bold = true } },
        { 'Ins', { fg = c.emerald, bold = true } },
        { 'Vis', { fg = c.purple, bold = true } },
        { 'Comm', { fg = c.yellow, bold = true } },
        { 'Rplc', { fg = c.crimson, bold = true } },
        -- Git
        { 'GBranch', { fg = c.coral, bg = c.bg0 } },
        { 'GAdd', { fg = c.emerald, bg = c.bg0 } },
        { 'GChange', { fg = c.yellow, bg = c.bg0 } },
        { 'GDel', { fg = c.crimson, bg = c.bg0 } },
        -- Diagnostics
        { 'DiagErr', { fg = c.crimson, bg = c.bg0 } },
        { 'DiagWarn', { fg = c.yellow, bg = c.bg0 } },
        { 'DiagInfo', { fg = c.blue, bg = c.bg0 } },
        -- LSP
        { 'Lsp', { fg = c.grey236, bg = c.bg0 } },
    }

    for _, hl in ipairs(hls) do
        zLine_hl(0, hl[1], hl[2])
    end
end

zline_hls()
vim.api.nvim_create_autocmd('ColorScheme', { callback = zline_hls })

local MODES = {
    ['n'] = { 'NOR', 'Norm' },
    ['no'] = { 'NOR', 'Norm' },
    ['v'] = { 'VIS', 'Vis' },
    ['V'] = { 'V-L', 'Vis' },
    ['\22'] = { 'V-BL', 'Vis' }, -- Ctrl-V
    ['s'] = { 'SEL', 'Vis' },
    ['S'] = { 'S-L', 'Vis' },
    ['i'] = { 'INS', 'Ins' },
    ['R'] = { 'REP', 'Rplc' },
    ['c'] = { 'CMD', 'Comm' },
    ['r'] = { 'PRM', 'Comm' },
    ['!'] = { 'SH', 'Comm' },
    ['t'] = { 'TER', 'Ins' },
}

local function get_mode()
    local m = vim.api.nvim_get_mode().mode
    local mode_data = MODES[m] or { m, 'Norm' }
    return string.format('%%#%s# %s ', mode_data[2], mode_data[1])
end

local _devicons
local function get_file_info()
    local filename = vim.fn.expand '%:t'
    if filename == '' then
        return ' [No Name] '
    end

    local ext = filename:match '%.([^%.]+)$' or ''
    if _devicons == nil then
        local ok, m = pcall(require, 'nvim-web-devicons')
        _devicons = ok and m or false
    end

    local icon = ''
    if _devicons then
        icon = _devicons.get_icon(filename, ext, { default = true }) or ''
    end

    return string.format('%%#StatusLine#%s %s ', icon, filename)
end

local function get_git()
    local dict = vim.b.gitsigns_status_dict
    if not dict then
        return ''
    end

    local branch = dict.head and string.format('%%#GBranch# %s ', dict.head) or ''
    local added = (dict.added and dict.added > 0) and string.format('%%#GAdd#+%s ', dict.added) or ''
    local changed = (dict.changed and dict.changed > 0) and string.format('%%#GChange#~%s ', dict.changed) or ''
    local removed = (dict.removed and dict.removed > 0) and string.format('%%#GDel#-%s ', dict.removed) or ''

    return branch .. added .. changed .. removed
end

local function get_diagnostics()
    local err_count, warn_count, info_count = 0, 0, 0
    local sev = vim.diagnostic.severity
    for _, d in ipairs(vim.diagnostic.get(0)) do
        if d.severity == sev.ERROR then
            err_count = err_count + 1
        elseif d.severity == sev.WARN then
            warn_count = warn_count + 1
        elseif d.severity == sev.INFO then
            info_count = info_count + 1
        end
    end

    local err_str = err_count > 0 and string.format('%%#DiagErr#✖ %s ', err_count) or ''
    local warn_str = warn_count > 0 and string.format('%%#DiagWarn#⚠ %s ', warn_count) or ''
    local info_str = info_count > 0 and string.format('%%#DiagInfo# %s ', info_count) or ''
    return err_str .. warn_str .. info_str
end

-- LSP
local _lsp_cache = {}

local function upd_lsp_chache(bufnr)
    local clients = vim.lsp.get_clients { bufnr = bufnr }
    if #clients == 0 then
        _lsp_cache[bufnr] = ''
        return
    end
    local names = {}
    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end
    _lsp_cache[bufnr] = string.format('%%#Lsp#%s ', table.concat(names, ', '))
end

vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
    callback = function(args)
        upd_lsp_chache(args.buf)
    end,
})
vim.api.nvim_create_autocmd('BufEnter', {
    callback = function(args)
        if _lsp_cache[args.buf] == nil then
            upd_lsp_chache(args.buf)
        end
    end,
})
-- prevent buffers accumulating for closed ones
vim.api.nvim_create_autocmd('BufDelete', {
    callback = function(args)
        _lsp_cache[args.buf] = nil
    end,
})

local function get_active_lsp()
    local bufnr = vim.api.nvim_get_current_buf()
    if _lsp_cache[bufnr] == nil then
        upd_lsp_chache(bufnr)
    end
    return _lsp_cache[bufnr]
end

local function nu_tabline()
    local symbol = '▪'
    local tabline = ''
    for i = 1, vim.fn.tabpagenr '$', 1 do
        tabline = tabline .. '%' .. i .. 'T'
        if vim.fn.tabpagenr() == i then
            tabline = tabline .. '%#TablineSelSymbol#' .. symbol .. '%#TablineSel# Tab:'
        else
            tabline = tabline .. '%#Tabline# Tab:'
        end
        tabline = tabline .. i .. '%T %#TablineFill#'
    end
    return tabline
end

-- Render statusline and tabline
function _G.ZTabline()
    return nu_tabline()
end

function _G.ZLine()
    local sep = '%#Sep# '
    local mode = get_mode()
    local file = get_file_info()
    local git = get_git()
    local diag = get_diagnostics()
    local lsp = get_active_lsp()
    local position = '%#StatusLine#%l:%c '
    local progress = '%#StatusLine#%L ↓%p%% '

    local active_left = {}
    for _, comp in ipairs { mode, file, lsp, git } do
        if comp ~= '' then
            table.insert(active_left, comp)
        end
    end

    return table.concat(active_left, sep) .. '%=' .. table.concat({ diag, position, progress }, sep)
end

vim.opt.statusline = '%!v:lua.ZLine()'
vim.opt.tabline = '%!v:lua.ZTabline()'
