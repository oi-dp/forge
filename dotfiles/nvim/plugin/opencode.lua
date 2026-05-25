local tmux_state = { pane_id = nil }
local opencode_cmd = 'opencode --port'
local fallback_terminal_opts = {
    win = {
        position = 'right',
        enter = false,
        on_win = function(win)
            require('opencode.terminal').setup(win.win)
        end,
    },
}

vim.pack.add { 'https://github.com/nickjvandyke/opencode.nvim' }

local opencode = require 'opencode'
local tmux = require 'lib.tmux'
local fallback_terminal = require 'snacks.terminal'

local open_tmux = function()
    tmux_state.pane_id = tmux.tmux_split { cmd = opencode_cmd, focus = false }
end

local stop_tmux = function()
    if tmux_state.pane_id ~= nil then
        tmux.tmux_kill_pane(tmux_state.pane_id)
        tmux_state.pane_id = nil
    end
end

vim.g.opencode_opts = {
    server = {
        start = function()
            if tmux.is_tmux_available() == false then
                fallback_terminal.open(opencode_cmd, fallback_terminal_opts)
                return
            end
            open_tmux()
        end,
        stop = function()
            if tmux.is_tmux_available() == false then
                fallback_terminal.get(opencode_cmd, fallback_terminal_opts):close()
                return
            end
            stop_tmux()
        end,
        toggle = function()
            if tmux.is_tmux_available() == false then
                return
            end
            if tmux_state.pane_id ~= nil then
                stop_tmux()
            else
                open_tmux()
            end
        end,
    },
}

keymap({ 'n', 'x' }, '<leader>aos', function()
    opencode.start()
end, 'Start')
keymap({ 'n', 'x' }, '<leader>aoe', function()
    opencode.select()
end, 'Execute')
keymap({ 'n', 'x' }, '<leader>aob', function()
    opencode.prompt '@buffer '
end, 'Add buffer to opencode')
keymap({ 'n', 'x' }, '<leader>aoB', function()
    opencode.prompt '@buffers '
end, 'Add all buffers to opencode')
keymap({ 'n', 'x' }, '<leader>aod', function()
    opencode.prompt '@diagnostics '
end, 'Add current buffer diagnostics to opencode')
keymap({ 'n', 'x' }, '<leader>aor', function()
    return require('opencode').operator '@this '
end, 'Add range to opencode', { expr = true })
keymap('n', '<leader>aol', function()
    return require('opencode').operator '@this ' .. '_'
end, 'Add line to opencode', { expr = true })
