--WORKSPACE
local workspace_rules = {
    { workspace = 'w[tv1]s[false]', gaps_out = 0, gaps_in = 0 },
    { workspace = 'f[1]s[false]', gaps_out = 0, gaps_in = 0 },
}

local window_rules = {
    { match = { float = false, workspace = 'w[tv1]s[false]' }, border_size = 0, rounding = 0 },
    { match = { float = false, workspace = 'f[1]s[false]' }, border_size = 0, rounding = 0 },
}

for _, rule in ipairs(workspace_rules) do
    hl.workspace_rule(rule)
end

for _, rule in ipairs(window_rules) do
    hl.window_rule(rule)
end

hl.workspace_rule({
    workspace = 'special:scratchpad',
    on_created_empty = 'foot -a foot-scratchpad ~/.config/hypr/scripts/watchdog.sh',
})

hl.workspace_rule({ workspace = '2', layout = 'dwindle' })

hl.on('workspace.active', function(ws)
    if not ws then
        return
    end

    local target_ratio = (ws.name == '2') and 1.25 or 1.0
    hl.config({
        dwindle = {
            default_split_ratio = target_ratio,
        },
    })
end)

-- WINDOWS
local suppressMaximizeRule = hl.window_rule({
    name = 'suppress-maximize-events',
    match = { class = '.*' },
    suppress_event = 'maximize',
})
-- default is set false
suppressMaximizeRule:set_enabled(true)

hl.window_rule({
    name = 'fix-wayland-drags',
    match = {
        class = '^$',
        title = '^$',
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

-- bottles
hl.window_rule({
    name = 'bottles-winx',
    match = { class = 'com.usebottles.bottles' },
    float = true,
    size = '900 600',
})

-- easy effects
hl.window_rule({
    name = 'easy-effects-eq',
    match = { class = 'org.kde.easyeffects' },
    float = true,
    size = '1025 675',
})

-- foot
hl.window_rule({
    match = { class = 'foot-scratchpad' },
    float = false,
    maximize = 1,
})

hl.window_rule({
    name = 'foot-explorer',
    match = { class = 'foot' },
    float = true,
    size = '1000 600',
})

-- proton mail
hl.window_rule({
    name = 'proton-mail-electron',
    match = { class = 'Proton Mail' },
    float = true,
    size = '1000 900',
})

-- proton pass
hl.window_rule({
    name = 'proton-pass-electron',
    match = { class = 'Proton Pass' },
    float = true,
    size = '1000 700',
})

-- spotify
hl.window_rule({
    name = 'spotify',
    match = { class = 'Spotify' },
    float = true,
    size = '1080 800',
})

-- tradovate
hl.window_rule({
    name = 'Tradovate-Trader',
    match = { class = 'tradovate trader.exe' },
    maximize = 1,
    no_blur = true,
    opacity = '1.0 override 1.0 override',
})

-- video player
hl.window_rule({
    name = 'video-player',
    match = { class = 'org.gnome.Showtime' },
    no_blur = true,
    opacity = '1.0 override 1.0 override',
    float = true,
    size = '700 500',
})

-- virtual surround sound
hl.window_rule({
    name = 'virtual-surround-sound',
    match = { class = 'de.berny23.virtual_surround_manager' },
    float = true,
    size = '425 535',
})

-- zen browser
hl.window_rule({
    name = 'zen-browser',
    match = { class = 'zen' },
    no_blur = true,
    opacity = '1.0 override 1.0 override',
})
