-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Custom Explorer
local explorer = require('core.explorer')
vim.keymap.set('n', '\\', explorer.toggle, { desc = 'Toggle custom tree explorer' })

-- Theme Picker
local themes = require('core.theme_picker')
vim.keymap.set('n', '<leader>th', themes.open, { desc = 'Open theme picker' })
