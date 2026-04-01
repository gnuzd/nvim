local M = {}
local colors_engine = require("core.colors")

local themes = {
    "onedark",
    "catppuccin",
}

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

function M.open()
    vim.ui.select(themes, {
        prompt = "Select Theme:",
        format_item = function(item)
            return item:gsub("^%l", string.upper)
        end,
    }, function(choice)
        if choice then
            local status, theme_colors = pcall(require, "themes." .. choice)
            if status then
                colors_engine.apply_highlights(theme_colors)
                save_theme(choice)
                vim.notify("Applied and saved theme: " .. choice)
            else
                vim.notify("Error loading theme: " .. choice, vim.log.levels.ERROR)
            end
        end
    end)
end

-- Load the saved theme on startup
local saved = get_saved_theme()
local status, theme_colors = pcall(require, "themes." .. saved)
if status then
    colors_engine.apply_highlights(theme_colors)
else
    -- Fallback to onedark if saved theme fails
    local ok, default_theme = pcall(require, "themes.onedark")
    if ok then
        colors_engine.apply_highlights(default_theme)
    end
end

return M
