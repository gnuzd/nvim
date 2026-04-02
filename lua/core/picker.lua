local M = {}
local api = vim.api

function M.open(opts)
  -- opts: title, items, on_select, on_change, format_item, previewer, on_type
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.8)
  local list_width = math.floor(width * 0.35)
  local prompt_height = 3
  
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local items = opts.items or {}
  local selected_idx = 1
  local filter = ""
  local prompt_prefix = "   "
  local prefix_len = #prompt_prefix
  local original_win = api.nvim_get_current_win()
  
  -- 1. Create Buffers
  local results_buf = api.nvim_create_buf(false, true)
  local preview_buf = api.nvim_create_buf(false, true)
  local prompt_buf = api.nvim_create_buf(false, true)

  -- 2. Create Windows
  local prompt_win = api.nvim_open_win(prompt_buf, true, {
    relative = "editor",
    width = list_width,
    height = 1,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " " .. (opts.title or "Search") .. " ",
    title_pos = "center",
  })

  local results_win = api.nvim_open_win(results_buf, false, {
    relative = "editor",
    width = list_width,
    height = height - prompt_height - 1,
    row = row + prompt_height,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Results ",
    title_pos = "center",
  })

  local preview_win = api.nvim_open_win(preview_buf, false, {
    relative = "editor",
    width = width - list_width - 2,
    height = height - 1,
    row = row,
    col = col + list_width + 2,
    style = "minimal",
    border = "rounded",
    title = " Preview ",
    title_pos = "center",
  })

  api.nvim_win_set_option(preview_win, "number", true)
  api.nvim_win_set_option(preview_win, "wrap", true)
  if opts.preview_ft then
    api.nvim_buf_set_option(preview_buf, "filetype", opts.preview_ft)
  end

  local ns_id = api.nvim_create_namespace("PickerUI")
  local last_filtered = {}

  local function render()
    local ok_k, keyword_hl = pcall(api.nvim_get_hl_by_name, "Keyword", true)
    local bar_color = ok_k and keyword_hl.foreground or 0xF38BA8
    local ok_v, visual_hl = pcall(api.nvim_get_hl_by_name, "Visual", true)
    local visual_bg = ok_v and visual_hl.background or nil
    api.nvim_set_hl(0, "PickerBar", { 
      fg = string.format("#%06x", bar_color), 
      bg = visual_bg and string.format("#%06x", visual_bg) or nil,
      bold = true 
    })

    local filtered = {}
    if opts.on_type then
      filtered = items
    else
      for _, item in ipairs(items) do
        local search_str = type(item) == "table" and (item.name or item[1]) or item
        if search_str:lower():find(filter:lower(), 1, true) then
          table.insert(filtered, item)
        end
      end
    end
    last_filtered = filtered

    if selected_idx > #filtered then selected_idx = math.max(1, #filtered) end
    if selected_idx < 1 and #filtered > 0 then selected_idx = 1 end

    local results_lines = {}
    for i, item in ipairs(filtered) do
      local display = opts.format_item and opts.format_item(item) or (type(item) == "table" and item.name or item)
      local char = (i == selected_idx) and "▌" or " "
      local line = char .. display
      local padding = string.rep(" ", list_width - #line - 1)
      table.insert(results_lines, line .. padding)
    end
    api.nvim_buf_set_option(results_buf, "modifiable", true)
    api.nvim_buf_set_lines(results_buf, 0, -1, false, results_lines)
    api.nvim_buf_set_option(results_buf, "modifiable", false)

    api.nvim_buf_clear_namespace(results_buf, -1, 0, -1)
    for i, _ in ipairs(filtered) do
      if i == selected_idx then
        api.nvim_buf_add_highlight(results_buf, -1, "PickerBar", i - 1, 0, 3)
        api.nvim_buf_add_highlight(results_buf, -1, "Visual", i - 1, 3, -1)
      else
        api.nvim_buf_add_highlight(results_buf, -1, "Comment", i - 1, 0, -1)
      end
    end

    local info = string.format("%d/%d", selected_idx, #filtered)
    api.nvim_buf_clear_namespace(prompt_buf, ns_id, 0, -1)
    api.nvim_buf_set_extmark(prompt_buf, ns_id, 0, 0, {
      virt_text = { { info, "Comment" } },
      virt_text_pos = "right_align",
    })

    if filtered[selected_idx] and opts.previewer then
      opts.previewer(filtered[selected_idx], preview_buf, preview_win)
    end
    if filtered[selected_idx] and opts.on_change then
      opts.on_change(filtered[selected_idx])
    end
  end

  api.nvim_buf_set_lines(prompt_buf, 0, -1, false, { prompt_prefix })
  api.nvim_buf_add_highlight(prompt_buf, -1, "Function", 0, 1, 4)
  render()

  local function close()
    vim.cmd("stopinsert")
    if api.nvim_win_is_valid(results_win) then api.nvim_win_close(results_win, true) end
    if api.nvim_win_is_valid(preview_win) then api.nvim_win_close(preview_win, true) end
    if api.nvim_win_is_valid(prompt_win) then api.nvim_win_close(prompt_win, true) end
    if api.nvim_win_is_valid(original_win) then api.nvim_set_current_win(original_win) end
  end

  local function confirm()
    local selected_item = last_filtered[selected_idx]
    close()
    if selected_item and opts.on_select then
      opts.on_select(selected_item)
    end
  end

  local key_opts = { buffer = prompt_buf, nowait = true, silent = true }
  
  local mouse_keys = { "<LeftMouse>", "<RightMouse>", "<MiddleMouse>", "<ScrollWheelUp>", "<ScrollWheelDown>" }
  for _, key in ipairs(mouse_keys) do
    vim.keymap.set({ "n", "i", "v" }, key, "<nop>", { buffer = prompt_buf })
    vim.keymap.set({ "n", "i", "v" }, key, "<nop>", { buffer = results_buf })
    vim.keymap.set({ "n", "i", "v" }, key, "<nop>", { buffer = preview_buf })
  end

  local function move_next()
    local count = #last_filtered
    if count == 0 then return end
    selected_idx = (selected_idx % count) + 1
    render()
  end
  
  local function move_prev()
    local count = #last_filtered
    if count == 0 then return end
    selected_idx = (selected_idx - 2 + count) % count + 1
    render()
  end

  vim.keymap.set("i", "<Tab>", move_next, key_opts)
  vim.keymap.set("i", "<S-Tab>", move_prev, key_opts)
  vim.keymap.set("i", "<Down>", move_next, key_opts)
  vim.keymap.set("i", "<Up>", move_prev, key_opts)
  vim.keymap.set("i", "<CR>", confirm, key_opts)
  vim.keymap.set("i", "<Esc>", function() if opts.on_cancel then opts.on_cancel() end; close() end, key_opts)

  api.nvim_create_autocmd("CursorMovedI", {
    buffer = prompt_buf,
    callback = function()
      local cursor = api.nvim_win_get_cursor(prompt_win)
      if cursor[2] < prefix_len then
        api.nvim_win_set_cursor(prompt_win, {1, prefix_len})
      end
    end
  })

  api.nvim_buf_attach(prompt_buf, false, {
    on_lines = function(_, _, _, _, _, _)
      vim.schedule(function()
        if not api.nvim_buf_is_valid(prompt_buf) then return end
        local line = api.nvim_buf_get_lines(prompt_buf, 0, 1, false)[1] or ""
        if not line:match("^   ") then
          local content = line:gsub("^%s*%s*", "")
          api.nvim_buf_set_lines(prompt_buf, 0, 1, false, { prompt_prefix .. content })
          api.nvim_win_set_cursor(prompt_win, {1, prefix_len + #content})
          line = prompt_prefix .. content
        end

        local new_filter = line:sub(prefix_len + 1)
        if new_filter ~= filter then
          filter = new_filter
          if opts.on_type then
            opts.on_type(filter, function(new_items)
              items = new_items
              selected_idx = 1
              render()
            end)
          else
            selected_idx = 1
            render()
          end
        end
      end)
    end
  })

  vim.cmd("startinsert!")
  api.nvim_win_set_cursor(prompt_win, {1, prefix_len})
end

return M
