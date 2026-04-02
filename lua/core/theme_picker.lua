local M = {}
local colors_engine = require("core.colors")
local picker = require("core.picker")
local api = vim.api

-- Path to store the selected theme
local theme_cache_path = vim.fn.stdpath("data") .. "/theme_dev.txt"

local function save_theme(theme)
  local f = io.open(theme_cache_path, "w")
  if f then
    f:write(theme)
    f:close()
  end
end

local function get_saved_theme()
  local f = io.open(theme_cache_path, "r")
  if f then
    local content = f:read("*all")
    f:close()
    if content then
      return content:gsub("%s+", "")
    end
  end
  return "onedark" -- Default fallback
end

local function get_available_themes()
  local themes = {}
  local themes_dir = vim.fn.stdpath("config") .. "/lua/themes"
  local files = vim.fn.globpath(themes_dir, "*.lua", false, true)
  
  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    local status, palette = pcall(require, "themes." .. name)
    if status then
      table.insert(themes, {
        name = name,
        palette = palette
      })
    end
  end
  return themes
end

local function apply_theme(name, silent)
  local status, theme_colors = pcall(require, "themes." .. name)
  if status then
    colors_engine.apply_highlights(theme_colors)
    if not silent then
      save_theme(name)
    end
  elseif not silent then
    vim.notify("Error loading theme: " .. name, vim.log.levels.ERROR)
  end
end

local sample_code = [[
local M = {}

-- This is a sample function to demonstrate syntax highlighting
function M.calculate_sum(a, b)
  local result = a + b
  print("Calculating sum of " .. a .. " and " .. b)
  return result
end

-- Tables and strings
local colors = {
  red = "#ff0000",
  green = "#00ff00",
  blue = "#0000ff"
}

-- Boolean and numbers
local is_active = true
local count = 42

if is_active then
  M.calculate_sum(10, 20)
end

return M
]]

function M.open()
  local themes = get_available_themes()
  local initial_theme = get_saved_theme()
  
  picker.open({
    title = "Theme Picker",
    items = themes,
    preview_ft = "lua",
    on_select = function(item)
      apply_theme(item.name)
    end,
    on_change = function(item)
      -- Live preview
      apply_theme(item.name, true)
    end,
    on_cancel = function()
      apply_theme(initial_theme, true)
    end,
    previewer = function(item, buf, win)
      api.nvim_buf_set_option(buf, "modifiable", true)
      api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(sample_code, "\n"))
      api.nvim_buf_set_option(buf, "modifiable", false)
    end
  })
end

-- Startup theme loading
local saved = get_saved_theme()
local status, theme_colors = pcall(require, "themes." .. saved)
if status then
  colors_engine.apply_highlights(theme_colors)
else
  local ok_def, default_theme = pcall(require, "themes.onedark")
  if ok_def then
    colors_engine.apply_highlights(default_theme)
  end
end

return M
