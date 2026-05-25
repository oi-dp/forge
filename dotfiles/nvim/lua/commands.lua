vim.api.nvim_create_user_command('PackUpdate', function(opts)
    if opts.args:match '%S' then
        local plugins = vim.split(opts.args, '%s+', { trimempty = true })
        vim.pack.update(plugins)
    else
        vim.pack.update()
    end
end, { desc = 'Update plugins' })

vim.api.nvim_create_user_command('PackDel', function(opts)
    vim.pack.del(opts.fargs)
end, { nargs = '+', desc = 'Delete plugins' })

vim.api.nvim_create_user_command('PackList', function()
    print(vim.inspect(vim.pack.get()))
end, { desc = 'List installed plugins' })
