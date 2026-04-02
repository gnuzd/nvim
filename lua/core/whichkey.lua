local M = {}
local api = vim.api

-- Configuration
local menu_win = nil
local results_win = nil
local results_buf = nil
local prompt_buf = nil
local prompt_win = nil

local function close_menu()
  vim.cmd("stopinsert")
  if prompt_win and api.nvim_win_is_valid(prompt_win) then api.nvim_win_close(prompt_win, true) end
  if results_win and api.nvim_win_is_valid(results_win) then api.nvim_win_close(results_win, true) end
end

function M.show_menu()
  local width = 45
  local prompt_height = 3
  local max_results = 12
  
  -- 1. Get Core Keymaps (those with a description)
  local all_maps = api.nvim_get_keymap('n')
  local buf_maps = api.nvim_buf_get_keymap(0, 'n')
  for _, v in ipairs(buf_maps) do table.insert(all_maps, v) end

  local core_items = {}
  local seen = {}
  local leader = vim.g.mapleader or " "
  
  for _, map in ipairs(all_maps) do
    if map.desc and map.desc ~= "" and map.lhs ~= "?" then
      local lhs = map.lhs:gsub(leader, "<leader>")
      if not seen[lhs] then
        table.insert(core_items, { key = lhs, desc = map.desc, raw_lhs = map.lhs })
        seen[lhs] = true
      end
    end
  end
  table.sort(core_items, function(a, b) return a.key < b.key end)

  local filter = ""
  local selected_idx = 1
  local prefix = "   "
  local prefix_len = #prefix

  -- 2. Create Buffers and Windows
  results_buf = api.nvim_create_buf(false, true)
  prompt_buf = api.nvim_create_buf(false, true)

  local function render()
    local filtered = {}
    for _, item in ipairs(core_items) do
      if item.key:lower():find(filter:lower(), 1, true) or item.desc:lower():find(filter:lower(), 1, true) then
        table.insert(filtered, item)
      end
    end

    if selected_idx > #filtered then selected_idx = math.max(1, #filtered) end
    if selected_idx < 1 and #filtered > 0 then selected_idx = 1 end

    -- Update Results
    local lines = {}
    for i, item in ipairs(filtered) do
      local line = string.format("▌ %-12s ➜  %s", item.key, item.desc)
      local padding = string.rep(" ", width - #line)
      table.insert(lines, line .. padding)
    end
    api.nvim_buf_set_option(results_buf, "modifiable", true)
    api.nvim_buf_set_lines(results_buf, 0, -1, false, lines)
    api.nvim_buf_set_option(results_buf, "modifiable", false)

    -- Results Highlighting
    api.nvim_buf_clear_namespace(results_buf, -1, 0, -1)
    for i = 1, #filtered do
      if i == selected_idx then
        api.nvim_buf_add_highlight(results_buf, -1, "Keyword", i - 1, 0, 3) -- Magenta Bar
        api.nvim_buf_add_highlight(results_buf, -1, "Visual", i - 1, 3, -1) -- Background
      else
        api.nvim_buf_add_highlight(results_buf, -1, "Comment", i - 1, 0, -1) -- Dimmed
      end
    end

    -- Update Prompt Info
    local info = string.format("%d/%d", selected_idx, #filtered)
    local ns_id = api.nvim_create_namespace("HelpUI")
    api.nvim_buf_clear_namespace(prompt_buf, ns_id, 0, -1)
    api.nvim_buf_set_extmark(prompt_buf, ns_id, 0, 0, {
      virt_text = { { info, "Comment" } },
      virt_text_pos = "right_align",
    })
    
    return filtered
  end

  local win_height = math.min(#core_items, max_results)
  
  results_win = api.nvim_open_win(results_buf, false, {
    relative = "editor",
    width = width,
    height = win_height,
    row = vim.o.lines - win_height - 3,
    col = vim.o.columns - width - 2,
    style = "minimal",
    border = "rounded",
    title = " Help ",
    title_pos = "center",
  })

  prompt_win = api.nvim_open_win(prompt_buf, true, {
    relative = "editor",
    width = width,
    height = 1,
    row = vim.o.lines - win_height - prompt_height - 2,
    col = vim.o.columns - width - 2,
    style = "minimal",
    border = "rounded",
    title = " Search Keymaps ",
    title_pos = "center",
  })

  api.nvim_buf_set_lines(prompt_buf, 0, -1, false, { prefix })
  api.nvim_buf_add_highlight(prompt_buf, -1, "Function", 0, 1, 4)
  local filtered_results = render()

  -- Disable mouse interaction
  local mouse_keys = { "<LeftMouse>", "<RightMouse>", "<MiddleMouse>", "<ScrollWheelUp>", "<ScrollWheelDown>" }
  for _, key in ipairs(mouse_keys) do
    vim.keymap.set({ "n", "i", "v" }, key, "<nop>", { buffer = prompt_buf })
    vim.keymap.set({ "n", "i", "v" }, key, "<nop>", { buffer = results_buf })
  end

  -- Navigation and Execution
  local opts = { buffer = prompt_buf, nowait = true, silent = true }
  
  vim.keymap.set("i", "<Tab>", function() selected_idx = (selected_idx % #filtered_results) + 1; filtered_results = render() end, opts)
  vim.keymap.set("i", "<S-Tab>", function() selected_idx = (selected_idx - 2 + #filtered_results) % #filtered_results + 1; filtered_results = render() end, opts)
  vim.keymap.set("i", "<CR>", function()
    local item = filtered_results[selected_idx]
    close_menu()
    if item then
      -- Execute the keymap by feeding keys
      api.nvim_feedkeys(api.nvim_replace_termcodes(item.raw_lhs, true, true, true), "m", true)
    end
  end, opts)
  vim.keymap.set("i", "<Esc>", close_menu, opts)

  -- Search overlap protection
  api.nvim_create_autocmd("CursorMovedI", {
    buffer = prompt_buf,
    callback = function()
      local cursor = api.nvim_win_get_cursor(prompt_win)
      if cursor[2] < prefix_len then api.nvim_win_set_cursor(prompt_win, {1, prefix_len}) end
    end
  })

  -- Typing track
  api.nvim_buf_attach(prompt_buf, false, {
    on_lines = function(_, _, _, _, _, _)
      vim.schedule(function()
        if not api.nvim_buf_is_valid(prompt_buf) then return end
        local line = api.nvim_buf_get_lines(prompt_buf, 0, 1, false)[1] or ""
        if not line:match("^" .. prefix) then
          api.nvim_buf_set_lines(prompt_buf, 0, 1, false, { prefix .. line:gsub("^%s*%s*", "") })
          api.nvim_win_set_cursor(prompt_win, {1, prefix_len})
          line = prefix
        end
        filter = line:sub(prefix_len + 1)
        filtered_results = render()
      end)
    end
  })

  vim.cmd("startinsert!")
  api.nvim_win_set_cursor(prompt_win, {1, prefix_len})
end

function M.setup() end

return M
