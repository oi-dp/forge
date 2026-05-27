hl.config({
    input = {
        kb_layout = 'us',
        repeat_rate = 35,
        repeat_delay = 200,
        follow_mouse = 1,
        accel_profile = 'custom 0.2144477506 0.000 0.307 0.615 1.077 1.539 2.002 2.505 3.208 3.910 4.63 5.315 6.018 6.720 7.423 8.125 8.828 9.530 10.233 10.935 12.387',
        sensitivity = 0,
        float_switch_override_focus = false,
    },
})

local funck = require('modules.funck')
local cmd = hl.dsp.exec_cmd
local window = hl.dsp.window

local term = 'alacritty'
local term2 = 'ghostty +new-window' -- enable ghostty systemd service to use new-window
local files = 'foot yazi'
local menu = 'hyprlauncher'
local browser = 'zen-browser'

local mod = 'SUPER + '
local s_mod = 'SUPER + SHIFT + '
local alt = 'ALT + '
local s_alt = 'ALT + SHIFT + '

local binds = {
    { mod .. 'RETURN', cmd(term) },
    { mod .. 'T', cmd(term2) },
    { mod .. 'SPACE', cmd(menu) },
    { mod .. 'E', cmd(files) },
    { mod .. 'F', cmd(browser) },
    { mod .. 'X', funck.floatfoot },
    { s_mod .. 'W', cmd('pkill waybar; waybar') },
    { s_mod .. 'R', cmd('hyprctl reload') },
    { s_alt .. 'L', cmd('hyprlock') },
    { s_alt .. 'P', funck.cycles },
    { alt .. 'Q', window.close() },
    { s_mod .. 'F', window.float({ action = 'toggle' }) },
    { mod .. 'TAB', window.fullscreen({ action = 'toggle' }) },
    { 'Print', funck.capture },

    -- Move focus
    { mod .. 'H', hl.dsp.focus({ direction = 'l' }) },
    { mod .. 'L', hl.dsp.focus({ direction = 'r' }) },
    { mod .. 'K', hl.dsp.focus({ direction = 'u' }) },
    { mod .. 'J', hl.dsp.focus({ direction = 'd' }) },

    -- Scratchpad
    { mod .. 'S', hl.dsp.workspace.toggle_special('scratchpad') },
    { s_mod .. 'S', window.move({ workspace = 'special:scratchpad' }) },

    -- Move/resize windows with mouse
    { mod .. 'mouse:272', window.drag(), { mouse = true } },
    { mod .. 'mouse:273', window.resize(), { mouse = true } },

    -- Playerctl
    { 'XF86AudioNext', cmd('playerctl next'), { locked = false } },
    { 'XF86AudioPause', cmd('playerctl play-pause'), { locked = false } },
    { 'XF86AudioPlay', cmd('playerctl play-pause'), { locked = false } },
    { 'XF86AudioPrev', cmd('playerctl previous'), { locked = false } },
}

for _, bind in ipairs(binds) do
    hl.bind(bind[1], bind[2], bind[3] or {})
end

for i = 1, 9 do
    local key = i % 9
    hl.bind(mod .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(s_mod .. key, window.move({ workspace = i }))
end

hl.bind(alt .. 'TAB', function()
    hl.dispatch(window.cycle_next())
    hl.dispatch(window.bring_to_top())
end)

-- resize windows position
hl.bind(s_alt .. 'R', hl.dsp.submap('resize'))

hl.define_submap('resize', function()
    local directions = {
        { key = 'right', x = 10, y = 0 },
        { key = 'left', x = -10, y = 0 },
        { key = 'up', x = 0, y = 10 },
        { key = 'down', x = 0, y = -10 },
    }

    for _, d in ipairs(directions) do
        hl.bind(d.key, window.resize({ x = d.x, y = d.y, relative = true }), { repeating = true })
    end

    hl.bind('escape', hl.dsp.submap('reset'))
end)

-- Move windows position
local move_window = {
    { key = 'a', dir = 'l' },
    { key = 'd', dir = 'r' },
    { key = 'w', dir = 'u' },
    { key = 's', dir = 'd' },
}

for _, m in ipairs(move_window) do
    hl.bind(s_alt .. m.key, window.move({ direction = m.dir }))
end

hl.on('config.reloaded', function()
    hl.exec_cmd("notify-send 'Hyprland' 'Config reloaded'")
end)
