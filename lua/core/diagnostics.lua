local M = {}
local api = vim.api
local icons = require('core.icons')

local state = {
  buf = nil,
  win = nil,
}

function M.toggle()
  if state.win and api.nvim_win_is_valid(state.win) then
    api.nvim_win_close(state.win, true)
    state.win = nil
    return
  end

  if not state.buf or not api.nvim_buf_is_valid(state.buf) then
    state.buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(state.buf, 'filetype', 'diag-list')
    api.nvim_buf_set_option(state.buf, 'buftype', 'nofile')
  end

  vim.cmd('botright split')
  state.win = api.nvim_get_current_win()
  api.nvim_win_set_buf(state.win, state.buf)
  api.nvim_win_set_height(state.win, 10)
  
  local wo = vim.wo[state.win]
  wo.number = false
  wo.relativenumber = false
  wo.signcolumn = 'no'
  wo.cursorline = true

  M.render()
  
  -- Keymaps for the diagnostic window
  local opts = { buffer = state.buf, silent = true }
  vim.keymap.set('n', '<CR>', function()
    local line = api.nvim_win_get_cursor(state.win)[1]
    local diags = vim.diagnostic.get(0)
    local diag = diags[line]
    if diag then
      api.nvim_win_close(state.win, true)
      state.win = nil
      api.nvim_win_set_cursor(0, { diag.lnum + 1, diag.col })
    end
  end, opts)
  vim.keymap.set('n', 'q', M.toggle, opts)
end

function M.render()
  if not state.buf or not api.nvim_buf_is_valid(state.buf) then return end
  
  local diags = vim.diagnostic.get(0)
  local lines = {}
  local hl_data = {}

  for i, diag in ipairs(diags) do
    local severity_icon = icons.Error
    local hl_group = "DiagListError"
    
    if diag.severity == vim.diagnostic.severity.WARN then
      severity_icon = icons.Warn
      hl_group = "DiagListWarn"
    elseif diag.severity == vim.diagnostic.severity.INFO then
      severity_icon = icons.Info
      hl_group = "DiagListInfo"
    elseif diag.severity == vim.diagnostic.severity.HINT then
      severity_icon = icons.Hint
      hl_group = "DiagListHint"
    end

    local line = string.format(" %s %3d:%-2d  %s", severity_icon, diag.lnum + 1, diag.col + 1, diag.message)
    table.insert(lines, line)
    table.insert(hl_data, { line = i - 1, col_start = 1, col_end = 4, group = hl_group })
  end

  if #lines == 0 then
    table.insert(lines, " No diagnostics found ")
  end

  api.nvim_buf_set_option(state.buf, 'modifiable', true)
  api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  api.nvim_buf_set_option(state.buf, 'modifiable', false)

  local ns = api.nvim_create_namespace("DiagList")
  api.nvim_buf_clear_namespace(state.buf, ns, 0, -1)
  for _, hl in ipairs(hl_data) do
    api.nvim_buf_add_highlight(state.buf, ns, hl.group, hl.line, hl.col_start, hl.col_end)
  end
end

-- Update list when diagnostics change
api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    if state.win and api.nvim_win_is_valid(state.win) then
      M.render()
    end
  end,
})

return M
