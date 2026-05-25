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

local term = 'alacritty'
local term2 = 'ghostty +new-window' -- enable systemd.service to use new-window
local files = 'foot yazi'
local menu = 'hyprlauncher'
local browser = 'zen-browser'

local mod = 'SUPER + '
local s_mod = 'SUPER + SHIFT + '
local alt = 'ALT + '
local s_alt = 'ALT + SHIFT + '

local binds = {
    { mod .. 'RETURN', hl.dsp.exec_cmd(term) },
    { mod .. 'T', hl.dsp.exec_cmd(term2) },
    { mod .. 'SPACE', hl.dsp.exec_cmd(menu) },
    { mod .. 'E', hl.dsp.exec_cmd(files) },
    { mod .. 'F', hl.dsp.exec_cmd(browser) },
    { mod .. 'X', funck.floatfoot },
    { s_mod .. 'W', hl.dsp.exec_cmd('pkill waybar; waybar') },
    { s_mod .. 'R', hl.dsp.exec_cmd('hyprctl reload') },
    { s_alt .. 'L', hl.dsp.exec_cmd('hyprlock') },
    { s_alt .. 'P', funck.cycles },
    { alt .. 'Q', hl.dsp.window.close() },
    { s_mod .. 'F', hl.dsp.window.float({ action = 'toggle' }) },
    { mod .. 'TAB', hl.dsp.window.fullscreen({ action = 'toggle' }) },
    { 'Print', funck.capture },

    -- Move focus
    { mod .. 'H', hl.dsp.focus({ direction = 'l' }) },
    { mod .. 'L', hl.dsp.focus({ direction = 'r' }) },
    { mod .. 'K', hl.dsp.focus({ direction = 'u' }) },
    { mod .. 'J', hl.dsp.focus({ direction = 'd' }) },

    -- Scratchpad
    { mod .. 'S', hl.dsp.workspace.toggle_special('scratchpad') },
    { s_mod .. 'S', hl.dsp.window.move({ workspace = 'special:scratchpad' }) },

    -- Move/resize windows with mouse
    { mod .. 'mouse:272', hl.dsp.window.drag(), { mouse = true } },
    { mod .. 'mouse:273', hl.dsp.window.resize(), { mouse = true } },

    -- Playerctl (locked only, no repeat)
    { 'XF86AudioNext', hl.dsp.exec_cmd('playerctl next'), { locked = true } },
    { 'XF86AudioPause', hl.dsp.exec_cmd('playerctl play-pause'), { locked = true } },
    { 'XF86AudioPlay', hl.dsp.exec_cmd('playerctl play-pause'), { locked = true } },
    { 'XF86AudioPrev', hl.dsp.exec_cmd('playerctl previous'), { locked = true } },

    -- Multimedia keys (repeating + locked)
    {
        'XF86AudioRaiseVolume',
        hl.dsp.exec_cmd('wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+'),
        { locked = true, repeating = true },
    },
    {
        'XF86AudioLowerVolume',
        hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'),
        { locked = true, repeating = true },
    },
    {
        'XF86AudioMute',
        hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'),
        { locked = true, repeating = true },
    },
    {
        'XF86AudioMicMute',
        hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'),
        { locked = true, repeating = true },
    },
}

for _, bind in ipairs(binds) do
    hl.bind(bind[1], bind[2], bind[3] or {})
end

for i = 1, 9 do
    local key = i % 9
    hl.bind(mod .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(s_mod .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(alt .. 'TAB', function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
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
        hl.bind(d.key, hl.dsp.window.resize({ x = d.x, y = d.y, relative = true }), { repeating = true })
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
    hl.bind(s_alt .. m.key, hl.dsp.window.move({ direction = m.dir }))
end

hl.on('config.reloaded', function()
    hl.exec_cmd("notify-send 'Hyprland' 'Config reloaded'")
end)
