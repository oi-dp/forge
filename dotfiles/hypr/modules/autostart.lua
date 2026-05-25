local autostart = {
    'waybar',
    'hyprpaper',
    'mako',
    -- 'hyprlauncher -d', -- not sure if it's worth it to run it as daemon
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

-- use nwg look for this
-- hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Graphite-dark"')
-- hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
-- hl.exec_cmd('gsettings set org.gnome.desktop.interface cursor-theme "Future-cyan-cursor"')
