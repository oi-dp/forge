-- techbase colors modified

vim.cmd 'hi clear'
if vim.fn.exists 'syntax_on' == 1 then
    vim.cmd 'syntax reset'
end
vim.g.colors_name = 'techbase'

-- ─── Palette ──────────────────────────────────────────────────────────────────
local c = {
    -- foreground
    normal_fg = '#CCD5E5',
    float_fg = '#D6DDEA',
    nontext_fg = '#363848',
    comment_fg = '#474B65',
    quote_fg = '#7E8193',
    float_border_fg = '#2A2F39',

    -- background
    normal_bg = '#080808',
    normal_embed_bg = '#20252E',
    float_bg = '#080808',
    float_bg_select = '#1F242D',
    panel_bg = '#1B1F25',

    -- accent
    v_select = '#13214B',
    v_select_nontext = '#32416F',
    string = '#74BAA8',
    raw_string = '#0EC256',
    cursor = '#5DCD9A',
    operator = '#b09884',
    constant = '#BCB6EC',
    keyword = '#A9B9EF',
    important = '#6A8BE3',
    search = '#E9B872',
    number = '#B85B53',

    -- notifications
    info = '#1A8C9B',
    warn = '#FFA630',
    error = '#FF5454',

    -- git
    git_add_bg = '#1E3A34',
    git_delete_bg = '#3A1A21',
    git_change_bg = '#1F2B5C',
    git_add_fg = '#9FDACC',
    git_delete_fg = '#FFC0C5',
    git_change_fg = '#B7C4FF',
    git_add_col = '#366A4C',
    git_delete_col = '#942B27',
    git_change_col = '#3F58BB',
}

-- ─── Utility ──────────────────────────────────────────────────────────────────

---Lighten or darken a hex colour by `percent`.
---@param hex string
---@param percent number  positive = lighter, negative = darker
---@return string
local function tint(hex, percent)
    local r, g, b = hex:match '^#?(%x%x)(%x%x)(%x%x)$'
    r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
    local function convert(ch)
        ch = math.floor(ch * (100 + percent) / 100 + 0.5)
        return ch > 255 and 255 or ch
    end
    return ('#%02x%02x%02x'):format(convert(r), convert(g), convert(b))
end

-- ─── Highlight groups ─────────────────────────────────────────────────────────
local hl = {}

-- windows
hl['Normal'] = { fg = c.normal_fg, bg = c.normal_bg }
hl['NormalFloat'] = { fg = c.float_fg, bg = c.float_bg }
hl['FloatBorder'] = { fg = c.float_border_fg, bg = c.float_bg }
hl['FloatTitle'] = { fg = c.important, bg = c.float_bg }
hl['WinSeparator'] = { fg = c.normal_embed_bg }

-- diff
hl['Added'] = { fg = c.git_add_fg, bg = c.git_add_bg }
hl['Changed'] = { fg = c.git_change_fg, bg = c.git_change_bg }
hl['Removed'] = { fg = c.git_delete_fg, bg = c.git_delete_bg }

-- elements
hl['ColorColumn'] = { bg = c.normal_embed_bg }
hl['Conceal'] = { fg = 'fg' }
hl['CurSearch'] = { fg = c.normal_bg, bg = c.number }
hl['Cursor'] = { bg = c.cursor }
hl['CursorLine'] = { bg = c.normal_embed_bg }
hl['CursorLineNr'] = { fg = 'fg' }
hl['Delimiter'] = { fg = 'fg' }
hl['Directory'] = { fg = c.important }
hl['EndOfBuffer'] = { link = 'NonText' }
hl['Error'] = { fg = c.error }
hl['ErrorMsg'] = { link = 'Error' }
hl['FoldColumn'] = { link = 'NonText' }
hl['Folded'] = { fg = c.keyword, bg = c.normal_embed_bg }
hl['IncSearch'] = { link = 'Search' }
hl['LineNr'] = { link = 'NonText' }
hl['MatchParen'] = { fg = c.search, bg = c.normal_embed_bg }
hl['ModeMsg'] = { fg = c.constant }
hl['MoreMsg'] = { link = 'ModeMsg' }
hl['MsgArea'] = { fg = 'fg' }
hl['MsgSeparator'] = { fg = c.float_bg }
hl['NonText'] = { fg = c.nontext_fg }
hl['Pmenu'] = { fg = c.float_fg, bg = c.float_bg }
hl['PmenuMatch'] = { fg = c.important }
hl['PmenuSbar'] = { link = 'Pmenu' }
hl['PmenuSel'] = { bg = c.float_bg_select }
hl['PmenuMatchSel'] = { link = 'PmenuSel' }
hl['PmenuThumb'] = { bg = c.nontext_fg }
hl['Question'] = { fg = c.string }
hl['QuickFixLine'] = { link = 'Search' }
hl['Search'] = { fg = c.normal_bg, bg = c.search }
hl['SignColumn'] = { fg = 'fg' }
hl['SpecialChar'] = { link = 'Special' }
hl['SpecialComment'] = { fg = c.search }
hl['SpecialKey'] = { fg = c.search }
hl['Substitute'] = { fg = c.string, bg = c.normal_embed_bg }
hl['TermCursor'] = { link = 'Cursor' }
hl['Title'] = { link = 'Directory' }
hl['Todo'] = { link = 'SpecialComment' }
hl['Visual'] = { bg = c.v_select }
hl['WarningMsg'] = { link = 'Error' }
hl['Whitespace'] = { link = 'NonText' }
hl['WinBar'] = { fg = c.float_fg }
hl['WinBarNC'] = { link = 'WinBar' }

-- StatusLine groups
hl['StatusLine'] = { fg = c.normal_fg, bg = c.panel_bg }
hl['StatusLineNC'] = {}
hl['Sep'] = { fg = c.normal_fg }

hl['Norm'] = { fg = c.important, bold = true }
hl['Ins'] = { fg = c.raw_string, bold = true }
hl['Vis'] = { fg = c.constant, bold = true }
hl['Comm'] = { fg = c.search, bold = true }
hl['Rplc'] = { fg = c.number, bold = true }

hl['GBranch'] = { fg = c.operator }
hl['GAdd'] = { fg = c.git_add_col }
hl['GChange'] = { fg = c.git_change_col }
hl['GDel'] = { fg = c.git_delete_col }

hl['DiagErr'] = { fg = c.error }
hl['DiagWarn'] = { fg = c.warn }
hl['DiagInfo'] = { fg = c.info }

hl['Lsp'] = { fg = c.normal_fg }

hl['Tabline'] = { fg = c.quote_fg, bg = c.normal_bg }
hl['TablineFill'] = { fg = c.quote_fg, bg = c.normal_bg }
hl['TablineSel'] = { fg = c.normal_fg, bg = c.float_bg_select, bold = true }
hl['TablineSelSymbol'] = { fg = c.important, bg = c.float_bg_select }

-- Syntax
hl['Comment'] = { fg = c.comment_fg }
hl['Constant'] = { fg = c.constant }
hl['Function'] = { fg = c.important }
hl['Keyword'] = { fg = c.keyword }
hl['Number'] = { fg = c.number }
hl['Operator'] = { fg = c.operator }
hl['String'] = { fg = c.string }
hl['Type'] = { fg = c.keyword }

hl['Boolean'] = { link = 'Constant' }
hl['Character'] = { link = 'String' }
hl['Conditional'] = { link = 'Statement' }
hl['Define'] = { link = 'PreProc' }
hl['Exception'] = { link = 'Statement' }
hl['Float'] = { link = 'Number' }
hl['Identifier'] = { fg = 'fg' }
hl['Include'] = { link = 'PreProc' }
hl['Label'] = { link = 'Conditional' }
hl['Macro'] = { link = 'PreProc' }
hl['PreCondit'] = { link = 'PreProc' }
hl['PreProc'] = { fg = 'fg' }
hl['Repeat'] = { link = 'Conditional' }
hl['Special'] = { fg = 'fg' }
hl['Statement'] = { link = 'Keyword' }
hl['StorageClass'] = { link = 'Type' }
hl['Structure'] = { link = 'Type' }
hl['Tag'] = { fg = 'fg' }
hl['Typedef'] = { link = 'Type' }

-- Filetype
-- diff
hl['DiffAdd'] = { link = 'Added' }
hl['DiffChange'] = { link = 'Changed' }
hl['DiffDelete'] = { link = 'Removed' }
hl['DiffText'] = { bg = c.important }

-- Gitcommit diffs
hl['diffAdded'] = { link = 'Added' }
hl['diffChanged'] = { link = 'Changed' }
hl['diffRemoved'] = { link = 'Removed' }

-- Gitcommit (info above the diff in a commit)
hl['gitcommitHeader'] = {}
hl['gitcommitOnBranch'] = {}
hl['gitcommitType'] = { fg = c.constant }
hl['gitcommitArrow'] = { link = 'Statement' }
hl['gitcommitBlank'] = { link = 'Added' }
hl['gitcommitBranch'] = { link = 'Added' }
hl['gitcommitDiscarded'] = { link = 'Added' }
hl['gitcommitDiscardedFile'] = { link = 'Added' }
hl['gitcommitDiscardedType'] = { link = 'Removed' }
hl['gitcommitSummary'] = { link = 'Directory' }
hl['gitcommitUnmerged'] = { link = 'Added' }

-- Help
hl['helpCommand'] = { fg = 'fg' }
hl['helpExample'] = { link = 'String' }
hl['helpHyperTextEntry'] = { link = 'Directory' }
hl['helpOption'] = { fg = 'fg' }
hl['helpVim'] = { fg = 'fg' }

-- Markdown
hl['markdownBlockquote'] = { fg = c.quote_fg }
hl['markdownCodeBlock'] = { bg = c.normal_embed_bg }
hl['markdownHeadingRule'] = { link = 'markdownRule' }
hl['markdownLinkText'] = { link = 'String' }
hl['markdownListMarker'] = { fg = 'fg' }
hl['markdownRule'] = { link = 'NonText' }
hl['markdownUrl'] = { link = '@text.uri' }

-- ini
hl['dosiniHeader'] = { link = '@markup.heading.1.markdown' }
hl['dosiniLabel'] = { link = '@property' }

-- ── Treesitter ────────────────────────────────────────────────────────────────

hl['@constant.builtin'] = { link = 'Constant' }
hl['@function.call'] = { fg = 'fg' }
hl['@function.method.call'] = { fg = 'fg' }
hl['@markup.heading'] = { link = 'Function' }
hl['@markup.raw.block'] = { link = 'markdownCodeBlock' }
hl['@method.call'] = { fg = 'fg' }
hl['@module'] = { fg = 'fg' }
hl['@namespace'] = { fg = c.important }
hl['@number.comment'] = { link = 'Comment' }
hl['@property'] = { fg = 'fg' }
hl['@punctuation'] = { fg = 'fg' }
hl['@string.documentation'] = { link = 'Comment' }
hl['@string.escape'] = { link = '@string.regex' }
hl['@string.regex'] = { fg = c.raw_string }
hl['@string.special.symbol'] = { link = '@string.regex' }
hl['@text.literal'] = { fg = 'fg' }
hl['@text.reference'] = { link = 'String' }
hl['@text.uri'] = { fg = c.keyword, underline = true }
hl['@type.builtin'] = { link = '@type' }

-- LaTeX
hl['@markup.link.label'] = { link = 'String' }
hl['@markup.link.latex'] = { link = 'Keyword' }
hl['@markup.environment.latex'] = { link = 'markdownCodeBlock' }
hl['@module.latex'] = { link = 'Function' }
hl['@punctuation.special.latex'] = { link = 'Function' }

for level = 1, 4 do
    hl['@markup.heading.' .. level .. '.latex'] = { link = 'String' }
end

-- Markdown (Treesitter)
hl['@conceal.markdown_inline'] = { link = 'Operator' }
hl['@markup.link.markdown_inline'] = { fg = 'fg' }
hl['@markup.list.checked.markdown'] = { link = 'DiagnosticOk' }
hl['@markup.list.unchecked.markdown'] = { link = 'DiagnosticError' }
hl['@markup.quote.markdown'] = { link = 'markdownBlockquote' }
hl['@markup.raw.markdown_inline'] = { fg = c.keyword, bg = c.normal_embed_bg }
hl['@punctuation.special.markdown'] = { link = '@markup.quote.markdown' }

for level = 1, 6 do
    hl['@markup.heading.' .. level .. '.markdown'] = { fg = c.important }
end

-- Comment keywords
for comment_type, color in pairs {
    error = { bg = c.error, fg = c.normal_fg },
    danger = { bg = c.error, fg = c.normal_fg },
    warning = { bg = c.warn, fg = c.normal_bg },
    todo = { bg = c.keyword, fg = c.normal_bg },
    note = { bg = c.normal_fg, fg = c.normal_bg },
} do
    hl['@comment.' .. comment_type] = color
    hl['@comment.' .. comment_type .. '.comment'] = color
end

-- ── LSP ───────────────────────────────────────────────────────────────────────

-- Diagnostics
for type, color in pairs {
    Error = c.error,
    Warn = c.warn,
    Info = c.info,
    Hint = c.float_fg,
    Ok = c.raw_string,
} do
    hl['Diagnostic' .. type] = { fg = color }
    hl['DiagnosticSign' .. type] = { fg = color }
    hl['DiagnosticVirtualText' .. type] = { fg = color }
    hl['DiagnosticUnderline' .. type] = { sp = tint(color, -15), undercurl = true }
end
hl['DiagnosticUnnecessary'] = { fg = hl['Comment']['fg'], undercurl = true }

hl['LspCodeLens'] = { fg = c.nontext_fg }
hl['LspSignatureActiveParameter'] = { sp = c.normal_fg, underline = true }
hl['LspReferenceTarget'] = { link = 'Substitute' }

-- ── Plugins ───────────────────────────────────────────────────────────────────

-- Treesitter context
hl['TreesitterContext'] = { bg = c.float_bg }
hl['TreesitterContextBottom'] = { underline = true, sp = c.float_border_fg }
hl['TreesitterContextLineNumber'] = { fg = c.nontext_fg, bg = c.float_bg }
hl['TreesitterContextLineNumberBottom'] = { underline = true, sp = c.float_border_fg }

-- Blink
hl['BlinkCmpDoc'] = { link = 'Pmenu' }
hl['BlinkCmpDocBorder'] = { fg = c.float_bg_border, bg = c.float_bg }
hl['BlinkCmpDocSeparator'] = { fg = c.float_bg_border }
hl['BlinkCmpGhostText'] = { link = 'NonText' }
hl['BlinkCmpKind'] = { fg = c.important }
hl['BlinkCmpLabel'] = { fg = c.float_fg }
hl['BlinkCmpLabelDescription'] = { fg = c.nontext_fg }
hl['BlinkCmpLabelDetail'] = { link = 'NonText' }
hl['BlinkCmpLabelMatch'] = { link = 'PmenuMatch' }
hl['BlinkCmpMenuBorder'] = { fg = hl['FloatBorder']['fg'], bg = hl['Pmenu']['bg'] }
hl['BlinkCmpMenuSelection'] = { link = 'PmenuMatchSel' }

-- GitSigns
hl['GitSignsAdd'] = { fg = c.git_add_col }
hl['GitSignsChange'] = { fg = c.git_change_col }
hl['GitSignsDelete'] = { fg = c.git_delete_col }
hl['GitSignsChangedelete'] = { link = 'GitSignsChange' }
hl['GitSignsTopdelete'] = { link = 'GitSignsDelete' }
hl['GitSignsUntracked'] = { link = 'NonText' }
hl['GitSignsStagedAdd'] = { fg = tint(c.git_add_col, -50) }
hl['GitSignsStagedChange'] = { fg = tint(c.git_change_col, -50) }
hl['GitSignsStagedDelete'] = { fg = tint(c.git_delete_col, -50) }
hl['GitSignsStagedChangedelete'] = { link = 'GitSignsStagedChange' }
hl['GitSignsStagedTopdelete'] = { link = 'GitSignsStagedDelete' }
hl['GitSignsStagedUntracked'] = { link = 'GitSignsStagedAdd' }
hl['GitSignsCurrentLineBlame'] = { link = 'NonText' }
hl['GitSignsAddInline'] = { link = 'Added' }
hl['GitSignsAddLnInline'] = { fg = 'fg', bg = tint(c.git_add_bg, 75) }
hl['GitSignsDeleteInline'] = { link = 'Removed' }
hl['GitSignsDeleteLnInline'] = { fg = 'fg', bg = tint(c.git_delete_bg, 75) }
hl['GitSignsChangeInline'] = { link = 'DiffText' }
hl['GitSignsChangeLnInline'] = { link = 'Changed' }
hl['GitSignsDeleteVirtLn'] = { link = 'Removed' }
hl['GitSignsDeleteVirtLnInLine'] = { link = 'Removed' }
hl['GitSignsVirtLnum'] = { link = 'LineNr' }

-- hl_match_area
hl['MatchArea'] = { link = 'MatchParen' }

-- vim-highlighturl
hl['HighlightUrl'] = { link = '@text.uri' }

-- visual-whitespace
hl['VisualNonText'] = { fg = c.v_select_nontext, bg = c.v_select }

-- render-markdown
hl['RenderMarkdownH1Bg'] = { bg = c.v_select }

-- ─── Set highlights ───────────────────────────────────────────────────────────

for group, spec in pairs(hl) do
    vim.api.nvim_set_hl(0, group, spec)
end

-- Clear LSP semantic token highlights
for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
    vim.api.nvim_set_hl(0, group, {})
end
