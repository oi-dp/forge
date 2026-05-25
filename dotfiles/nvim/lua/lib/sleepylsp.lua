local uv = vim.uv or vim.loop

local config = {
    stop_timeout_ms = 1000 * 60 * 10, -- 10 minutes
    start_timeout_ms = 1000 * 3, -- 3 seconds
    ignore = {},
}

local timers = { stop = nil, start = nil }
local stopped = {}
local shutting_down = false

local M = {}

-- ── helpers ──────────────────────────────────────────────────────────────────

local function cancel(key)
    if timers[key] then
        timers[key]:stop()
        timers[key]:close()
        timers[key] = nil
    end
end

local function new_timer(key, timeout_ms, callback)
    cancel(key)
    local t = uv.new_timer()
    if not t then
        vim.notify(('sleepylsp: failed to create %s timer'):format(key), vim.log.levels.ERROR)
        return
    end
    timers[key] = t
    t:start(
        timeout_ms,
        0,
        vim.schedule_wrap(function()
            cancel(key)
            callback()
        end)
    )
end

-- ── stop logic ───────────────────────────────────────────────────────────────

local function stop_lsps()
    shutting_down = true

    for _, client in ipairs(vim.lsp.get_clients()) do
        if not vim.tbl_contains(config.ignore, client.name) then
            stopped[client.name] = true
            client:stop(true)
        end
    end

    shutting_down = false
end

-- ── start logic ──────────────────────────────────────────────────────────────

local function restart_lsps()
    local names = vim.tbl_keys(stopped)
    if #names == 0 then
        return
    end

    vim.notify(('sleepylsp: restarting %s'):format(table.concat(names, ', ')), vim.log.levels.INFO)

    vim.lsp.enable(names) -- no bufnr: re-enable globally
    stopped = {}
end

-- ── autocommands ─────────────────────────────────────────────────────────────

vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
        if timers.stop then
            return
        end
        new_timer('stop', config.stop_timeout_ms, stop_lsps)
    end,
})

vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufEnter' }, {
    callback = function()
        if shutting_down then
            return
        end

        -- Always cancel a pending stop on activity
        cancel('stop')

        if vim.tbl_isempty(stopped) then
            return
        end

        -- Debounce: reset start timer on every activity event
        new_timer('start', config.start_timeout_ms, restart_lsps)
    end,
})

-- ── public API ───────────────────────────────────────────────────────────────

function M.setup(opts)
    opts = opts or {}
    config.stop_timeout_ms = opts.stop_timeout_ms or config.stop_timeout_ms
    config.start_timeout_ms = opts.start_timeout_ms or config.start_timeout_ms
    config.ignore = opts.ignore or config.ignore
end

return M
