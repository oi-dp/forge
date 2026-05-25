-- stolen from: https://github.com/Luks17/dotfiles/blob/main/config/nvim/lua/tmux.lua
--

local tmux_args = { 'tmux', 'split-window', '-P', '-F', "'#{pane_id}'" }

---Check if tmux is available.
---@return boolean
local is_tmux_available = function()
    if vim.env.TMUX == nil or vim.env.TMUX == '' then
        return false
    end
    if vim.fn.executable('tmux') ~= 1 then
        return false
    end

    return true
end

---Create a tmux pane from Neovim.
---
---If not running inside a tmux session or if the `tmux` executable is not available,
---this returns `false` and does nothing.
---
---@param opts? table Optional settings.
---@param opts.direction? '"vertical"'|'"horizontal"' Split direction.
---  - `"vertical"`: side-by-side panes (tmux `split-window -h`) (default)
---  - `"horizontal"`: top/bottom panes (tmux `split-window -v`)
---@param opts.size? integer|string Size of the new pane.
---  - number: treated as "cells" (e.g. `15`)
---  - string: passed to tmux as-is (e.g. `"30%"`, `"10"`)
---  Note: tmux interprets size relative to the split direction.
---@param opts.focus? boolean Should automatically focus the new pane. If omitted, defaults to `true`.
---@param opts.cwd? string Working directory for the new tmux pane. If omitted, uses `vim.fn.getcwd()`.
---@param opts.cmd? string Command to run in the new pane. If omitted, the pane starts the default shell.
---@return string|nil pane_id New tmux pane id (e.g. `"%12"`), or `nil` on failure.
local function tmux_split(opts)
    opts = opts or {}

    if not is_tmux_available() then
        return nil
    end

    local args = vim.deepcopy(tmux_args)

    local dir = opts.direction or 'vertical'
    if dir == 'horizontal' then
        table.insert(args, '-v')
    else
        table.insert(args, '-h')
    end

    local size = opts.size or '33%'
    if size ~= nil then
        if type(size) == 'number' then
            vim.list_extend(args, { '-l', tostring(size) })
        elseif type(size) == 'string' then
            local s = vim.trim(size)
            local percent = s:match('^(%d+)%%$')
            if percent then
                vim.list_extend(args, { '-p', percent })
            else
                vim.list_extend(args, { '-l', s })
            end
        end
    end

    if opts.focus == nil then
        opts.focus = true
    end
    if not opts.focus then
        table.insert(args, '-d')
    end

    local cwd = opts.cwd or vim.fn.getcwd()
    if cwd and cwd ~= '' then
        vim.list_extend(args, { '-c', cwd })
    end

    if opts.cmd and opts.cmd ~= '' then
        vim.list_extend(args, { opts.cmd })
    end

    local out = vim.fn.system(args)
    if vim.v.shell_error ~= 0 then
        vim.notify(('tmux split failed: %s'):format(out), vim.log.levels.WARN)
        return nil
    end

    local pane_id = vim.trim(out)
    if pane_id == '' then
        return nil
    end

    vim.fn.system(string.format('tmux set-option -t %s -p allow-passthrough off', pane_id))

    return pane_id
end

---Kill a tmux pane by id.
---@param pane_id string The tmux pane id (e.g. "%12") returned by `tmux_split()`.
---@return boolean ok `true` if the pane was killed; `false` otherwise.
local function tmux_kill_pane(pane_id)
    if not is_tmux_available() then
        return false
    end

    if type(pane_id) ~= 'string' or vim.trim(pane_id) == '' then
        return false
    end

    local args = { 'tmux', 'kill-pane', '-t', vim.trim(pane_id) }
    vim.fn.system(args)
    return vim.v.shell_error == 0
end

return {
    tmux_split = tmux_split,
    tmux_kill_pane = tmux_kill_pane,
    is_tmux_available = is_tmux_available,
}
