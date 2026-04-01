-- Autocommands
local api = vim.api

-- Create a group for our config reloading to avoid duplicates
local config_group = api.nvim_create_augroup('ConfigReload', { clear = true })

local function reload_config()
    -- Clear the cache for all modules in our 'lua' folder
    -- This ensures that 'require' actually re-runs the code
    for name, _ in pairs(package.loaded) do
        -- Only clear our own custom modules, avoiding standard nvim ones
        if name:match('^core%.') then
            package.loaded[name] = nil
        end
    end

    -- Re-source init.lua
    local init_path = vim.fn.expand('$MYVIMRC')
    if vim.fn.filereadable(init_path) == 1 then
        dofile(init_path)
        vim.notify("Nvim config reloaded!", vim.log.levels.INFO)
    else
        vim.notify("Nvim config reload failed: $MYVIMRC not found", vim.log.levels.ERROR)
    end
end

-- Use a more robust pattern matching for config files
api.nvim_create_autocmd('BufWritePost', {
    group = config_group,
    pattern = {
        vim.fn.stdpath('config') .. '/*.lua',
        vim.fn.stdpath('config') .. '/**/*.lua'
    },
    callback = reload_config,
    desc = 'Reload nvim config on save',
})
