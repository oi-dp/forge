-- Experimental features
vim.loader.enable()
require('vim._core.ui2').enable {}

-- Setup
require 'settings'
require 'keymaps'
require 'commands'
require 'autocmds'
require 'lsp'
