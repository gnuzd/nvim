local M = {}

local modes = {
  ['n']  = { 'NORMAL', 'StatusLineNormal' },
  ['i']  = { 'INSERT', 'StatusLineInsert' },
  ['v']  = { 'VISUAL', 'StatusLineVisual' },
  ['V']  = { 'V-LINE', 'StatusLineVisual' },
  [''] = { 'V-BLOCK', 'StatusLineVisual' },
  ['c']  = { 'COMMAND', 'StatusLineCommand' },
  ['R']  = { 'REPLACE', 'StatusLineReplace' },
}

local function get_mode()
  local m = vim.api.nvim_get_mode().mode
  return modes[m] or { m, 'StatusLineNormal' }
end

local function get_git_branch()
  local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
  if branch ~= "" then
    return "  " .. branch .. " "
  end
  return ""
end

function M.setup()
  vim.opt.laststatus = 3 -- Global statusline
  vim.opt.statusline = "%!v:lua.require('core.statusline').render()"
end

local icons = require('core.icons')

local function get_lsp_info()
  local lsp_status = ""
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  
  -- Diagnostics (Errors only for now to match screenshot)
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  if errors > 0 then
    lsp_status = lsp_status .. "%#StatusLineError#" .. icons.Error .. " " .. errors .. " "
  end

  if #clients > 0 then
    local names = {}
    for _, client in ipairs(clients) do
      table.insert(names, client.name)
    end
    lsp_status = lsp_status .. "%#StatusLineLsp# 󰒓 LSP ~ " .. table.concat(names, ", ") .. " "
  end
  
  return lsp_status
end

function M.render()
  local mode_info = get_mode()
  local mode_label = mode_info[1]
  local mode_hl = mode_info[2]
  local ft = vim.bo.filetype

  local statusline = ""

  -- Mode
  statusline = statusline .. "%#" .. mode_hl .. "# " .. mode_label .. " "

  if ft == 'tree-explorer' then
    statusline = statusline .. "%#StatusLineFile# FILE EXPLORER "
  else
    -- File info
    statusline = statusline .. "%#StatusLineFile# %f %m "

    -- Git branch
    statusline = statusline .. "%#StatusLineGit#" .. get_git_branch()
  end

  -- Right side alignment
  statusline = statusline .. "%="

  if ft ~= 'tree-explorer' then
    statusline = statusline .. get_lsp_info()
  end

  -- Position
  statusline = statusline .. "%#StatusLinePos# %l:%c "

  return statusline
end

M.setup()

return M
