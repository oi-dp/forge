vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }

local autopairs = require 'nvim-autopairs'
local Rule = require 'nvim-autopairs.rule'

autopairs.setup {}

local brackets = { { '(', ')' }, { '{', '}' }, { '[', ']' }, { '<', '>' } }

autopairs.add_rules {
    Rule('<', '>'),
}

autopairs.add_rule(Rule(' ', ' ')
    :with_pair(function(opts)
        local pair = opts.line:sub(opts.col - 1, opts.col)
        for _, bracket in ipairs(brackets) do
            if pair == bracket[1] .. bracket[2] then
                return true
            end
        end
        return false
    end)
    :with_del(function(_)
        local col = vim.fn.col '.'
        local line = vim.fn.getline '.'
        local pair = line:sub(col - 2, col + 1)
        for _, bracket in ipairs(brackets) do
            if pair == bracket[1] .. '  ' .. bracket[2] then
                return true
            end
        end
        return false
    end)
    :with_move(function(opts)
        return opts.char == ' '
    end))
