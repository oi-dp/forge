local function map_split(buf_id, lhs, direction)
    local minifiles = require 'mini.files'
    local function rhs()
        local window = minifiles.get_explorer_state().target_window
        if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then
            return
        end
        local new_target_window
        vim.api.nvim_win_call(window, function()
            vim.cmd(direction .. 'split')
            new_target_window = vim.api.nvim_get_current_win()
        end)
        minifiles.set_target_window(new_target_window)
        minifiles.go_in { close_on_file = true }
    end
    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Splt ' .. string.sub(direction, 12) })
end

vim.pack.add { 'https://github.com/nvim-mini/mini.files' }
local minifiles = require 'mini.files'
minifiles.setup {
    mappings = {
        show_help = '?',
        go_in_plus = '<cr>',
        go_out_plus = 'Q',
    },
    content = {
        sort = function(entries)
            local function compare_alphanumerically(e1, e2)
                if e1.is_dir ~= e2.is_dir then
                    return e1.is_dir
                end
                if
                    e1.pre_digits ~= nil
                    and e2.pre_digits ~= nil
                    and e1.pre_digits == e2.pre_digits
                    and e1.digits ~= e2.digits
                then
                    return e1.digits < e2.digits
                end
                return e1.lower_name < e2.lower_name
            end

            local augmented = {}
            for i, entry in ipairs(entries) do
                local pre, digits = entry.name:match '^(%D*)(%d+)'
                augmented[i] = {
                    fs_type = entry.fs_type,
                    name = entry.name,
                    path = entry.path,
                    lower_name = entry.name:lower(),
                    is_dir = entry.fs_type == 'directory',
                    pre_digits = pre,
                    digits = digits and tonumber(digits),
                }
            end
            table.sort(augmented, compare_alphanumerically)
            for i, x in ipairs(augmented) do
                augmented[i] = { name = x.name, fs_type = x.fs_type, path = x.path }
            end
            return augmented
        end,
    },
    windows = { width_nofocus = 25 },
    options = { permanent_delete = true },
}

local minifiles_explorer_group = vim.api.nvim_create_augroup('minifiles_explorer', { clear = true })
vim.api.nvim_create_autocmd('User', {
    group = minifiles_explorer_group,
    pattern = 'MiniFilesExplorerOpen',
    callback = function()
        vim.g.minifiles_active = true
    end,
})
vim.api.nvim_create_autocmd('User', {
    group = minifiles_explorer_group,
    pattern = 'MiniFilesExplorerClose',
    callback = function()
        vim.g.minifiles_active = false
    end,
})
vim.api.nvim_create_autocmd('User', {
    desc = 'Add minifiles split keymaps',
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
        local buf_id = args.data.buf_id
        map_split(buf_id, '<C-w>s', 'belowright horizontal')
        map_split(buf_id, '<C-w>v', 'belowright vertical')
    end,
})
keymap('n', '<leader>e', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname ~= '' and vim.uv.fs_stat(bufname) then
        require('mini.files').open(bufname, false)
    end
end, 'File explorer')
