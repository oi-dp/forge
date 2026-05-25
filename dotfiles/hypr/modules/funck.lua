local M = {}

function M.floatfoot()
    local win = hl.get_active_window()
    if win == nil then
        return
    end
    local terminals = {
        Alacritty = true,
        foot = true,
        ['com.mitchellh.ghostty'] = true,
    }
    if terminals[win.class] then
        if not win.floating then
            hl.dispatch(hl.dsp.window.float({ action = 'toggle' }))
            hl.timer(function()
                hl.dispatch(hl.dsp.window.resize({ exact = true, x = 1366, y = 768 }))
            end, { timeout = 50, type = 'oneshot' })
        else
            hl.dispatch(hl.dsp.window.float({ action = 'toggle' }))
        end
    else
        hl.dispatch(hl.dsp.window.float({ action = 'toggle' }))
        hl.dispatch(hl.dsp.window.fullscreen({ action = 'maximize' }))
    end
end

function M.cycles()
    local home = os.getenv('HOME')
    local wallpaper_dir = home .. '/media/pictures/moonwalls'
    local cache_file = home .. '/.cache/cycles'
    local list_cache = home .. '/.cache/walls_list'

    local function mtime(path)
        local h = io.popen(string.format('stat -c %%Y "%s" 2>/dev/null', path))
        if not h then
            return 0
        end
        local t = tonumber(h:read('*all')) or 0
        h:close()
        return t
    end

    -- rebuild wallpaper_dir if is newer than cache
    local images = {}
    if mtime(wallpaper_dir) > mtime(list_cache) then
        local handle = io.popen(
            string.format(
                'find "%s" -maxdepth 1 -type f \\( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \\) | sort',
                wallpaper_dir
            )
        )
        if handle then
            local f_save = io.open(list_cache, 'w')
            for line in handle:lines() do
                table.insert(images, line)
                if f_save then
                    f_save:write(line .. '\n')
                end
            end
            handle:close()
            if f_save then
                f_save:close()
            end
        end
    else
        local f_list = io.open(list_cache, 'r')
        if f_list then
            for line in f_list:lines() do
                table.insert(images, line)
            end
            f_list:close()
        end
    end

    if #images == 0 then
        return
    end

    local current = ''
    local f_curr = io.open(cache_file, 'r')
    if f_curr then
        current = f_curr:read('*l') or ''
        f_curr:close()
    end

    local next_wall = images[1]
    for i = 1, #images do
        if images[i] == current then
            next_wall = images[i + 1] or images[1]
            break
        end
    end

    -- hyprpaper commands
    local cmds = { string.format('hyprctl hyprpaper preload "%s"', next_wall) }

    for _, monitor in ipairs(hl.get_monitors()) do
        table.insert(cmds, string.format('hyprctl hyprpaper wallpaper "%s,%s"', monitor.name, next_wall))
    end

    if current ~= '' and current ~= next_wall then
        table.insert(cmds, string.format('hyprctl hyprpaper unload "%s"', current))
    end

    -- prevents races on keybind mashing
    table.insert(cmds, string.format('echo "%s" > "%s"', next_wall, cache_file))

    os.execute('(' .. table.concat(cmds, ' ; ') .. ') &')
end

function M.capture()
    local path = string.format('%s/media/pictures/screenshots/%s.png', os.getenv('HOME'), os.date('%Y-%m-%d_%H-%M-%S'))
    hl.exec_cmd(string.format('sh -c \'grim -g "$(slurp -d)" "%s"\'', path))
end

return M
