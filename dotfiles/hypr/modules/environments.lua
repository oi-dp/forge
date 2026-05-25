local env = {
    HYPRCURSOR_THEME = 'Future-Cyan-Hyprcursor_Theme',
    HYPRCURSOR_SIZE = 32,
    XCURSOR_THEME = 'Future-cyan-cursor',
    XCURSOR_SIZE = 24,
    ELECTRON_OZONE_PLATFORM_HINT = 'auto',
}

for name, val in pairs(env) do
    hl.env(name, val)
end
