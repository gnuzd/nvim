local M = {}
local api = vim.api

local function get_mode()
  local mode_map = {
    ['n']  = { 'NORMAL', 'StatusLineNormal' },
    ['i']  = { 'INSERT', 'StatusLineInsert' },
    ['v']  = { 'VISUAL', 'StatusLineVisual' },
    ['V']  = { 'V-LINE', 'StatusLineVisual' },
    [' '] = { 'V-BLOCK', 'StatusLineVisual' },
    ['c']  = { 'COMMAND', 'StatusLineCommand' },
    ['R']  = { 'REPLACE', 'StatusLineReplace' },
  }
  local m = api.nvim_get_mode().mode
  return mode_map[m] or { 'NORMAL', 'StatusLineNormal' }
end

local function get_git_info()
  local handle = io.popen('git branch --show-current 2>/dev/null')
  local branch = handle:read('*l')
  handle:close()
  if branch and branch ~= "" then
    return "  " .. branch
  end
  return ""
end

local function get_lsp_status()
  local diagnostics = vim.diagnostic.get(0)
  local count = { 0, 0, 0, 0 }
  for _, d in ipairs(diagnostics) do
    count[d.severity] = count[d.severity] + 1
  end
  
  local status = ""
  if count[1] > 0 then status = status .. "  " .. count[1] end
  if count[2] > 0 then status = status .. "  " .. count[2] end
  
  -- Dynamic LSP Progress Spinner
  local lsp_core = require('core.lsp')
  if lsp_core then
    status = status .. lsp_core.get_progress_string()
  end
  
  return status
end

function M.active()
  local mode = get_mode()
  local git = get_git_info()
  local lsp = get_lsp_status()
  local file = " %f %m"
  local pos = " %l:%c "

  return table.concat({
    "%#", mode[2], "# ", mode[1], " ",
    "%#StatusLineFile#", file, " ",
    "%#StatusLineGit#", git, " ",
    "%=",
    "%#StatusLineLsp#", lsp, " ",
    "%#StatusLinePos#", pos,
  })
end

function M.setup()
  api.nvim_create_autocmd({ "WinEnter", "BufEnter", "ModeChanged", "DiagnosticChanged" }, {
    callback = function()
      vim.opt.statusline = "%!v:lua.require('core.statusline').active()"
    end,
  })
end

M.setup()

return M
