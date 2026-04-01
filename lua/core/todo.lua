local api = vim.api
local M = {}

function M.setup()
  -- Define matches for TODOs
  local function set_todo_highlights()
    vim.fn.matchadd('TodoComment', '\\<TODO\\>:')
    vim.fn.matchadd('FixmeComment', '\\<FIXME\\>:')
    vim.fn.matchadd('BugComment', '\\<BUG\\>:')
    vim.fn.matchadd('NoteComment', '\\<NOTE\\>:')
  end

  api.nvim_create_autocmd({'BufWinEnter', 'WinEnter'}, {
    callback = set_todo_highlights,
  })
end

function M.list()
  -- Simple search for TODOs in the current buffer and show in quickfix
  vim.cmd('vimgrep /\\v<(TODO|FIXME|BUG|NOTE)>:/g %')
  vim.cmd('copen')
end

M.setup()

return M
