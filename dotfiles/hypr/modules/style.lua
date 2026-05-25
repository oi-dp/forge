hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 4,
        border_size = 2,
        col = {
            active_border = 'rgba(eeeeeeee)',
            inactive_border = 'rgba(595959aa)',
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = 'dwindle',
    },
    dwindle = {
        preserve_split = true,
        force_split = 2,
        default_split_ratio = 1,
    },
    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 0.8,
        inactive_opacity = 0.75,
        shadow = {
            enabled = true,
            range = 5,
            render_power = 1,
            color = 0xee1a1a1a,
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 4,
            noise = 0.0120,
            contrast = 1.8,
            vibrancy = 0.2,
        },
    },
    misc = {
        disable_autoreload = true,
    },
})
