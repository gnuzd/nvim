local opt = vim.opt

opt.number = true           -- Show line numbers
opt.relativenumber = true   -- Show relative line numbers
opt.mouse = 'a'             -- Enable mouse support
opt.ignorecase = true       -- Case-insensitive searching
opt.smartcase = true        -- ... unless search contains capitals
opt.hlsearch = false        -- Clear search highlights after search
opt.wrap = false            -- Disable line wrapping
opt.breakindent = true      -- Keep indentation for wrapped lines
opt.tabstop = 4             -- Number of spaces a tab counts for
opt.shiftwidth = 4          -- Number of spaces for auto-indent
opt.expandtab = true        -- Use spaces instead of tabs
opt.termguicolors = true    -- Enable 24-bit RGB colors
opt.cursorline = true       -- Highlight the current line
opt.scrolloff = 10          -- Keep 10 lines above/below cursor

-- Simple statusline
vim.o.statusline = '%f %y %m %= %l:%c'
