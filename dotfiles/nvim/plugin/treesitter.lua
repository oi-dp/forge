vim.pack.add {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/windwp/nvim-ts-autotag',
    'https://github.com/nvim-treesitter/nvim-treesitter-context',
}

-- stylua: ignore start
local parsers = {
    'bash', 'css', 'fish', 'html', 'javascript', 'dockerfile',
    'json', 'lua', 'markdown', 'markdown_inline', 'php', 'scss',
    'python', 'rust', 'toml', 'typescript', 'vim', 'yaml', 'gitignore',
}
-- stylua: ignore end

local treesitter = require 'nvim-treesitter'
local treesitter_context = require 'treesitter-context'
require('nvim-ts-autotag').setup()

for _, parser in ipairs(parsers) do
    treesitter.install(parser)
end

treesitter_context.setup {
    max_lines = 3,
    multiline_threshold = 1,
    min_window_height = 20,
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = parsers,
    callback = function()
        vim.treesitter.start()
    end,
    desc = 'Start treesitter',
})

keymap('n', '[c', function()
    treesitter_context.go_to_context(vim.v.count1)
end, nil)

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
        local data = event.data
        if data.spec and data.spec.name == 'nvim-treesitter' then
            if data.kind == 'install' or data.kind == 'update' then
                vim.cmd 'TSUpdate'
            end
        end
    end,
})
