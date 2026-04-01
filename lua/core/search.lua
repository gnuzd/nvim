local M = {}
local api = vim.api

local function create_float_win()
  local buf = api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.8)
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
  return buf, win
end

function M.find_files()
  local buf, win = create_float_win()
  local temp_file = os.tmpname()
  
  -- Use rg to find files (respects gitignore) + fzf with preview
  local preview_cmd = "bat --style=numbers --color=always --line-range :500 {}"
  if vim.fn.executable("bat") == 0 then
    preview_cmd = "cat {}"
  end

  local fzf_cmd = string.format(
    "export FZF_DEFAULT_COMMAND='rg --files --hidden --glob \"!.git/*\"'; " ..
    "fzf --reverse --preview '%s' --preview-window 'right:60%%' > %s",
    preview_cmd, temp_file
  )

  vim.fn.termopen(fzf_cmd, {
    on_exit = function()
      if api.nvim_win_is_valid(win) then
        api.nvim_win_close(win, true)
      end
      
      local f = io.open(temp_file, "r")
      if f then
        local selected = f:read("*all"):gsub("\n", "")
        f:close()
        os.remove(temp_file)
        if selected ~= "" then
          vim.schedule(function()
            vim.cmd("edit " .. vim.fn.fnameescape(selected))
          end)
        end
      end
    end
  })
  vim.cmd("startinsert")
end

function M.live_grep()
  local buf, win = create_float_win()
  local temp_file = os.tmpname()
  
  -- FZF live grep with ripgrep
  local fzf_cmd = string.format(
    "fzf --reverse --disabled --ansi --query '' " ..
    "--preview 'bat --style=numbers --color=always --highlight-line {2} {1}' " ..
    "--preview-window 'right:60%%' " ..
    "--bind 'change:reload:rg --column --line-number --no-heading --color=always --smart-case {q} || true' " ..
    "--bind 'enter:become(echo {} | cut -d: -f1,2)' > %s",
    temp_file
  )

  vim.fn.termopen(fzf_cmd, {
    on_exit = function()
      if api.nvim_win_is_valid(win) then
        api.nvim_win_close(win, true)
      end
      
      local f = io.open(temp_file, "r")
      if f then
        local selected = f:read("*all"):gsub("\n", "")
        f:close()
        os.remove(temp_file)
        if selected ~= "" then
          local parts = vim.split(selected, ":")
          local file = parts[1]
          local line = parts[2]
          vim.schedule(function()
            vim.cmd("edit " .. vim.fn.fnameescape(file))
            if line then
              api.nvim_win_set_cursor(0, {tonumber(line), 0})
            end
          end)
        end
      end
    end
  })
  vim.cmd("startinsert")
end

return M
