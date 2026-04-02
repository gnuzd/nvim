local M = {}
local picker = require("core.picker")
local api = vim.api

-- Helper to get file content for preview
local function read_file(path)
  local lines = {}
  local f = io.open(path, "r")
  if not f then return { "Error: Could not read file" } end
  
  -- Read entire file for reliable grep preview (bounded for safety)
  local count = 0
  for line in f:lines() do
    table.insert(lines, line)
    count = count + 1
    if count > 5000 then break end 
  end
  f:close()
  return lines
end

function M.find_files()
  local handle = io.popen("rg --files --hidden --glob '!.git/*'")
  if not handle then return end
  local result = handle:read("*a")
  handle:close()

  local files = {}
  for file in result:gmatch("[^\r\n]+") do
    table.insert(files, file)
  end

  picker.open({
    title = "Find Files",
    items = files,
    on_select = function(file)
      vim.cmd("edit " .. vim.fn.fnameescape(file))
    end,
    previewer = function(file, buf, win)
      local lines = read_file(file)
      api.nvim_buf_set_option(buf, "modifiable", true)
      api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      api.nvim_buf_set_option(buf, "modifiable", false)
      local ft = vim.filetype.match({ filename = file })
      if ft then api.nvim_buf_set_option(buf, "filetype", ft) end
    end
  })
end

function M.live_grep()
  local current_query = ""
  
  picker.open({
    title = "Live Grep",
    items = {},
    on_type = function(query, refresh)
      current_query = query
      if #query < 3 then 
        refresh({})
        return 
      end

      local handle = io.popen(string.format("rg --column --line-number --no-heading --color=never --smart-case %q 2>/dev/null", query))
      if not handle then return end
      
      local matches = {}
      local count = 0
      for line in handle:lines() do
        local parts = vim.split(line, ":")
        if #parts >= 3 then
          table.insert(matches, {
            name = line,
            file = parts[1],
            lnum = tonumber(parts[2]),
            col = tonumber(parts[3]),
            text = table.concat(parts, ":", 4),
            query = query -- Store query for highlighting
          })
          count = count + 1
        end
        if count > 100 then break end 
      end
      handle:close()
      refresh(matches)
    end,
    format_item = function(item)
      return string.format("%s:%d", item.file, item.lnum)
    end,
    on_select = function(item)
      vim.cmd("edit " .. vim.fn.fnameescape(item.file))
      api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
    end,
    previewer = function(item, buf, win)
      local lines = read_file(item.file)
      api.nvim_buf_set_option(buf, "modifiable", true)
      api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      api.nvim_buf_set_option(buf, "modifiable", false)
      
      local ft = vim.filetype.match({ filename = item.file })
      if ft then api.nvim_buf_set_option(buf, "filetype", ft) end
      
      -- Center preview on match
      pcall(api.nvim_win_set_cursor, win, { item.lnum, 0 })
      vim.api.nvim_win_call(win, function()
        vim.cmd("normal! zz")
      end)

      -- Highlight matched text
      api.nvim_buf_clear_namespace(buf, -1, 0, -1)
      if item.query and item.query ~= "" then
        -- Find the match in the current line to get accurate length
        local line_text = lines[item.lnum] or ""
        local start_idx, end_idx = line_text:lower():find(item.query:lower(), 1, true)
        if start_idx then
          api.nvim_buf_add_highlight(buf, -1, "Search", item.lnum - 1, start_idx - 1, end_idx)
        end
      end
    end
  })
end

return M
