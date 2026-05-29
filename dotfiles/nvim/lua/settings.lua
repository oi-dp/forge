--stlua: ignore start
local opt = vim.opt

-- general
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_banner = 0
vim.g.mapleader = ' '
opt.number = true
opt.relativenumber = true
opt.numberwidth = 6
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.autoread = true
opt.writebackup = false
opt.foldenable = false

opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath 'data' .. '/scratchit'
opt.undofile = true

-- spellchecker
opt.spell = true
opt.spelllang = 'en_us'
opt.spellfile = vim.fn.stdpath 'config' .. '/spell/en.utf-8.add'

-- search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.laststatus = 3

opt.list = true
opt.listchars = { space = '.', tab = '  ↦' }
opt.clipboard = 'unnamedplus'
opt.completeopt = 'menuone,noselect,fuzzy,nosort'

-- indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- UI
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = 'yes'
-- opt.colorcolumn = '+1'
opt.wrap = false
opt.showmatch = true
opt.matchtime = 2
opt.cmdheight = 0
opt.synmaxcol = 300
opt.ruler = false
opt.pumheight = 10
opt.pumborder = 'bold'
opt.winborder = 'rounded'
opt.inccommand = 'split'
opt.splitbelow = true
opt.splitright = true

-- transparent supports
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })

opt.updatetime = 300
opt.redrawtime = 10000

-- disable checkhealth
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
--stylua: ignoree end
