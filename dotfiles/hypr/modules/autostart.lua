local autostart = {
    'waybar',
    'hyprpaper',
    'mako',
}

hl.on('hyprland.start', function()
    for _, cmd in ipairs(autostart) do
        hl.exec_cmd(cmd)
    end
end)

hl.on('hyprland.start', function()
    hl.exec_cmd('gnome-keyring-daemon --start --components=secrets')
    -- if this isn't working use os.execute()
    hl.exec_cmd('~/codespace/forge/scripts/init-session.sh')
end)
