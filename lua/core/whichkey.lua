local M = {}
local api = vim.api

local keymaps = {
  { group = "General", maps = {
    { key = "?", desc = "Show this help menu" },
    { key = "<leader>th", desc = "Open theme picker" },
    { key = "<C-s>", desc = "Save buffer (Normal/Insert/Visual)" },
    { key = "\\", desc = "Toggle file explorer" },
  }},
  { group = "Buffers", maps = {
    { key = "<Tab>", desc = "Next buffer" },
    { key = "<S-Tab>", desc = "Previous buffer" },
    { key = "<leader>x", desc = "Close buffer (with save prompt)" },
  }},
  { group = "LSP & Diagnostics", maps = {
    { key = "gd", desc = "Go to definition" },
    { key = "gr", desc = "Show references" },
    { key = "gi", desc = "Go to implementation" },
    { key = "K", desc = "Hover documentation" },
    { key = "<leader>rn", desc = "Rename symbol" },
    { key = "<leader>ca", desc = "Code action" },
    { key = "<leader>tt", desc = "Toggle diagnostics list" },
    { key = "<leader>td", desc = "List TODO comments" },
  }},
  { group = "Completion (Insert Mode)", maps = {
    { key = "<Tab>", desc = "Next item / Trigger completion" },
    { key = "<S-Tab>", desc = "Previous item" },
    { key = "<CR>", desc = "Confirm selection" },
  }},
}

function M.show()
  local buf = api.nvim_create_buf(false, true)
  local lines = { " CUSTOM KEYMAPS HELP", string.rep("─", 40), "" }
  
  for _, section in ipairs(keymaps) do
    table.insert(lines, " " .. section.group .. ":")
    for _, map in ipairs(section.maps) do
      table.insert(lines, string.format("  %-10s %s", map.key, map.desc))
    end
    table.insert(lines, "")
  end

  local width = 50
  local height = #lines + 2
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded'
  }

  local win = api.nvim_open_win(buf, true, opts)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  api.nvim_buf_set_option(buf, 'modifiable', false)
  
  -- Close on any key
  api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<CR>', { noremap = true, silent = true })
  api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
  api.nvim_buf_set_keymap(buf, 'n', '?', '<cmd>close<CR>', { noremap = true, silent = true })
end

vim.api.nvim_create_user_command("Help", M.show, {})

return M
