local api = vim.api
local icons = require('core.icons')

-- LSP Progress and Spinner tracking
local M = {}
M.progress_title = ""
M.progress_pct = nil
M.is_loading = false
M.spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
M.spinner_idx = 1
local spinner_timer = nil

local function start_spinner()
  if spinner_timer then return end
  spinner_timer = vim.loop.new_timer()
  spinner_timer:start(0, 100, vim.schedule_wrap(function()
    M.spinner_idx = (M.spinner_idx % #M.spinner_frames) + 1
    vim.cmd('redrawstatus')
  end))
end

local function stop_spinner()
  if spinner_timer then
    spinner_timer:stop()
    spinner_timer:close()
    spinner_timer = nil
  end
end

function M.get_progress_string()
  if not M.is_loading then return "" end
  return string.format(" %s %s%s", 
    M.spinner_frames[M.spinner_idx], 
    M.progress_title, 
    M.progress_pct and string.format(" %d%%%%", M.progress_pct) or "")
end

-- Diagnostic signs setup
local signs = { Error = icons.Error, Warn = icons.Warn, Hint = icons.Hint, Info = icons.Info }
for type, icon in pairs(signs) do
  vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
end

-- Common LSP keymaps and behavior
api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K', function()
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})

-- Handle LSP Progress for statusline
api.nvim_create_autocmd('LspProgress', {
  callback = function(args)
    local progress = args.data.params.value
    if progress.kind == 'begin' then
      M.progress_title = progress.title or "LSP"
      M.is_loading = true
      start_spinner()
    elseif progress.kind == 'report' then
      M.progress_pct = progress.percentage
    elseif progress.kind == 'end' then
      M.is_loading = false
      M.progress_pct = nil
      stop_spinner()
    end
    vim.cmd('redrawstatus')
  end,
})

return M
