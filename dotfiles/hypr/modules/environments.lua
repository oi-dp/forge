local env = {
    HYPRCURSOR_THEME = 'Bibata-Modern-Classic',
    HYPRCURSOR_SIZE = 20,
    XCURSOR_THEME = 'Bibata-Modern-Classic',
    XCURSOR_SIZE = 20,
    ELECTRON_OZONE_PLATFORM_HINT = 'auto',
}

for name, val in pairs(env) do
    hl.env(name, val)
end
