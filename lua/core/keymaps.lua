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

-- Help Menu
local wk = require('core.whichkey')
vim.keymap.set('n', '?', wk.show, { desc = 'Show help menu' })

-- TODO and Diagnostics
local todo = require('core.todo')
local diags = require('core.diagnostics')
vim.keymap.set('n', '<leader>td', todo.list, { desc = 'List TODOs' })
vim.keymap.set('n', '<leader>tt', diags.toggle, { desc = 'Toggle diagnostic list' })

-- Save with Ctrl+s
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<CR>', { desc = 'Save buffer' })

-- Buffer Management
vim.keymap.set('n', '<Tab>', function()
  if vim.bo.filetype ~= 'tree-explorer' then
    vim.cmd('bn')
  end
end, { desc = 'Next buffer' })

vim.keymap.set('n', '<S-Tab>', function()
  if vim.bo.filetype ~= 'tree-explorer' then
    vim.cmd('bp')
  end
end, { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>x', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
  if modified then
    local choice = vim.fn.confirm("Save changes?", "&Yes\n&No\n&Cancel")
    if choice == 1 then -- Yes
      vim.cmd('write')
      vim.cmd('bd')
    elseif choice == 2 then -- No
      vim.cmd('bd!')
    end
  else
    vim.cmd('bd')
  end
end, { desc = 'Close current buffer' })

-- Completion Keymaps
local function check_backspace()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

vim.keymap.set('i', '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  elseif not check_backspace() then
    return '<C-x><C-o>'
  else
    return '<Tab>'
  end
end, { expr = true, silent = true })

vim.keymap.set('i', '<S-Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>'
  else
    return '<S-Tab>'
  end
end, { expr = true, silent = true })

vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  else
    return '<CR>'
  end
end, { expr = true, silent = true })
