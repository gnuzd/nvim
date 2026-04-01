local M = {}
local api = vim.api

local state = {
    root = vim.fn.getcwd(),
    nodes = {},
    expanded_dirs = {},
    win = nil,
    buf = nil,
    show_hidden = false,
    show_ignored = false,
}

-- Nerd Font Icons to match screenshot
local icons = {
    folder_closed = "󰉋",
    folder_open   = "󰉋",
    file_default  = "󰈚",
    ts            = "󰛦",
    tsx           = "",
    js            = "󰈦",
    json          = "󰘦",
    css           = "󰌜",
    md            = "󰍔",
    conf          = "󰠱",
    lock          = "󰌾",
    docker        = "󰡨",
}

local function get_file_icon(name)
    local ext = name:match("^.+(%..+)$")
    if name:lower() == "dockerfile" then return icons.docker end
    if ext == ".ts" then return icons.ts
    elseif ext == ".tsx" then return icons.tsx
    elseif ext == ".js" or ext == ".mjs" then return icons.js
    elseif ext == ".json" then return icons.json
    elseif ext == ".css" then return icons.css
    elseif ext == ".md" then return icons.md
    elseif ext == ".conf" then return icons.conf
    elseif ext == ".lock" then return icons.lock
    end
    return icons.file_default
end

local function is_git_ignored(path)
    if state.show_ignored then return false end
    local handle = io.popen("git check-ignore " .. vim.fn.shellescape(path) .. " 2>/dev/null")
    if not handle then return false end
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end

local function get_nodes(dir, level)
    local nodes = {}
    local handle = vim.loop.fs_scandir(dir)
    if not handle then return nodes end

    while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end

        local path = dir .. '/' .. name
        local hidden = name:match("^%.")
        
        local should_show = true
        if hidden and not state.show_hidden then should_show = false end
        if should_show and not state.show_ignored and is_git_ignored(path) then should_show = false end

        if should_show then
            table.insert(nodes, {
                path = path, name = name, is_dir = type == 'directory',
                level = level, expanded = state.expanded_dirs[path] or false
            })
        end
    end

    table.sort(nodes, function(a, b)
        if a.is_dir ~= b.is_dir then return a.is_dir end
        return a.name:lower() < b.name:lower()
    end)
    return nodes
end

local function build_tree(dir, level, result, parent_is_last_map)
    local nodes = get_nodes(dir, level)
    for i, node in ipairs(nodes) do
        node.is_last = (i == #nodes)
        node.parent_is_last_map = vim.deepcopy(parent_is_last_map or {})
        table.insert(result, node)
        
        if node.is_dir and state.expanded_dirs[node.path] then
            local new_map = vim.deepcopy(node.parent_is_last_map)
            new_map[level] = node.is_last
            build_tree(node.path, level + 1, result, new_map)
        end
    end
end

local function render()
    if not state.buf or not api.nvim_buf_is_valid(state.buf) then return end
    
    state.nodes = {}
    build_tree(state.root, 0, state.nodes)

    local lines = {}
    local root_name = vim.fn.fnamemodify(state.root, ":t")
    table.insert(lines, icons.folder_open .. " " .. root_name)

    for _, node in ipairs(state.nodes) do
        local line = ""
        for i = 0, node.level - 1 do
            line = line .. (node.parent_is_last_map[i] and "  " or "│ ")
        end
        line = line .. (node.is_last and "└─ " or "├─ ")
        local icon = node.is_dir and (node.expanded and icons.folder_open or icons.folder_closed) or get_file_icon(node.name)
        table.insert(lines, line .. icon .. " " .. node.name)
    end

    api.nvim_buf_set_option(state.buf, 'modifiable', true)
    api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    api.nvim_buf_set_option(state.buf, 'modifiable', false)
end

local function handle_select()
    local idx = api.nvim_win_get_cursor(state.win)[1]
    local node_idx = idx - 1
    if node_idx < 1 then return end
    
    local node = state.nodes[node_idx]
    if node.is_dir then
        state.expanded_dirs[node.path] = not state.expanded_dirs[node.path]
        render()
        api.nvim_win_set_cursor(state.win, {idx, 0})
    else
        vim.cmd('wincmd l')
        vim.cmd('edit ' .. node.path)
    end
end

local function create_item()
    local idx = api.nvim_win_get_cursor(state.win)[1]
    local parent_dir = state.root
    
    if idx > 1 then
        local node = state.nodes[idx - 1]
        parent_dir = node.is_dir and node.path or vim.fn.fnamemodify(node.path, ":h")
    end

    vim.ui.input({ prompt = "New File/Folder (folder ends with /): " }, function(input)
        if not input or input == "" then return end
        
        local is_dir = input:match("/$")
        local full_path = parent_dir .. "/" .. input
        
        if is_dir then
            vim.fn.mkdir(full_path, "p")
            state.expanded_dirs[full_path:gsub("/$", "")] = true
        else
            vim.fn.writefile({}, full_path)
        end
        
        render()
    end)
end

local function delete_item()
    local idx = api.nvim_win_get_cursor(state.win)[1]
    if idx <= 1 then return end -- Don't delete root

    local node = state.nodes[idx - 1]
    local msg = string.format("Delete %s? (y/n): ", node.name)
    
    local confirm = vim.fn.confirm(msg, "&Yes\n&No", 2)
    if confirm == 1 then
        vim.fn.delete(node.path, "rf")
        if node.is_dir then
            state.expanded_dirs[node.path] = nil
        end
        render()
    end
end

function M.toggle()
    local current_win = api.nvim_get_current_win()
    if state.win and api.nvim_win_is_valid(state.win) then
        if current_win == state.win then
            api.nvim_win_close(state.win, true)
            state.win = nil
            return
        else
            api.nvim_set_current_win(state.win)
            return
        end
    end

    if not state.buf or not api.nvim_buf_is_valid(state.buf) then
        state.buf = api.nvim_create_buf(false, true)
        api.nvim_buf_set_option(state.buf, 'filetype', 'tree-explorer')
        api.nvim_buf_set_option(state.buf, 'buftype', 'nofile')
    end

    vim.cmd('topleft vsplit')
    state.win = api.nvim_get_current_win()
    api.nvim_win_set_buf(state.win, state.buf)
    api.nvim_win_set_width(state.win, 35)
    
    local wo = vim.wo[state.win]
    wo.winfixwidth = true
    wo.number = false
    wo.relativenumber = false
    wo.signcolumn = 'no'
    wo.cursorline = true
    wo.wrap = false

    render()

    local opts = { buffer = state.buf, noremap = true, silent = true }
    vim.keymap.set('n', '<CR>', handle_select, opts)
    vim.keymap.set('n', '<2-LeftMouse>', handle_select, opts)
    vim.keymap.set('n', 'a', create_item, opts)
    vim.keymap.set('n', 'd', delete_item, opts)
    vim.keymap.set('n', 'l', function()
        local idx = api.nvim_win_get_cursor(state.win)[1]
        local node_idx = idx - 1
        if node_idx < 1 then return end
        local node = state.nodes[node_idx]
        if node.is_dir then
            if not state.expanded_dirs[node.path] then
                state.expanded_dirs[node.path] = true
                render()
            end
        else
            handle_select()
        end
    end, opts)
    vim.keymap.set('n', 'h', function()
        local idx = api.nvim_win_get_cursor(state.win)[1]
        local node_idx = idx - 1
        if node_idx < 1 then return end
        local node = state.nodes[node_idx]
        if node.is_dir and state.expanded_dirs[node.path] then
            state.expanded_dirs[node.path] = false
            render()
        end
    end, opts)
    vim.keymap.set('n', 'H', function() state.show_hidden = not state.show_hidden; render() end, opts)
    vim.keymap.set('n', 'I', function() state.show_ignored = not state.show_ignored; render() end, opts)
    vim.keymap.set('n', 'Z', function() state.expanded_dirs = {}; render() end, opts)
    vim.keymap.set('n', 'q', M.toggle, opts)
end

return M
