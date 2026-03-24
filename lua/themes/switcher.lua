local M = {}

-- Just applies the theme to the current session (for preview)
M.apply_theme = function(theme_name, silent)
	local ok, _ = pcall(require, "themes." .. theme_name)
	if not ok then
		return
	end

	-- Mapping UI themes to actual colorschemes
	local colorscheme_map = {
		gruvbox = "gruvbox-material",
		onedark = "gruvbox-material",
	}

	-- Set a temporary global so init.lua knows which one to pick up during preview
	_G.preview_theme = theme_name

	-- Apply the actual colorscheme if mapped
	if colorscheme_map[theme_name] then
		vim.cmd.colorscheme(colorscheme_map[theme_name])
	end

	-- Reload themes and lualine
	package.loaded["themes"] = nil
	package.loaded["themes.init"] = nil
	package.loaded["themes." .. theme_name] = nil
	package.loaded["configs.lualine"] = nil
	package.loaded["themes.highlights"] = nil
	package.loaded["theme_state"] = nil

	-- Apply the new colors to lualine
	local status, err = pcall(require, "configs.lualine")
	if not status and not silent then
		vim.notify("Error reloading lualine: " .. tostring(err), vim.log.levels.ERROR)
	end

	-- Re-apply our custom UI/Syntax highlights
	require("themes.highlights").apply_highlights()
end

-- Saves the theme to disk for persistence
M.save_theme = function(theme_name)
	local config_path = vim.fn.stdpath("config")
	local state_path = config_path .. "/lua/theme_state.lua"

	local file = io.open(state_path, "w")
	if file then
		file:write("return { theme = '" .. theme_name .. "' }\n")
		file:close()
		_G.preview_theme = nil
		vim.notify("UI Theme saved: " .. theme_name, vim.log.levels.INFO)
	end
end

M.open_picker = function()
	local files = vim.api.nvim_get_runtime_file("lua/themes/*.lua", true)
	local items = {}
	local initial_theme = "gruvbox"

	local status, state = pcall(require, "theme_state")
	if status and state.theme then
		initial_theme = state.theme
	end

	for _, path in ipairs(files) do
		local name = vim.fn.fnamemodify(path, ":t:r")
		if name ~= "init" and name ~= "switcher" and name ~= "highlights" then
			local ok, theme_mod = pcall(require, "themes." .. name)
			if ok then
				-- Create custom highlights for the preview dots
				local c = theme_mod.colors
				vim.api.nvim_set_hl(0, "ThemeIconBg" .. name, { fg = c.black })
				vim.api.nvim_set_hl(0, "ThemeIconRed" .. name, { fg = c.red })
				vim.api.nvim_set_hl(0, "ThemeIconGreen" .. name, { fg = c.green })
				vim.api.nvim_set_hl(0, "ThemeIconBlue" .. name, { fg = c.blue })
				vim.api.nvim_set_hl(0, "ThemeIconYellow" .. name, { fg = c.yellow })

				table.insert(items, {
					text = name,
					value = name,
					preview_icons = {
						{ "󱓻 ", "ThemeIconBg" .. name },
						{ "󱓻 ", "ThemeIconRed" .. name },
						{ "󱓻 ", "ThemeIconGreen" .. name },
						{ "󱓻 ", "ThemeIconBlue" .. name },
						{ "󱓻 ", "ThemeIconYellow" .. name },
					},
				})
			end
		end
	end

	Snacks.picker.pick({
		source = "ui_themes",
		items = items,
		layout = "default",
		title = " UI Themes ",
		format = function(item, picker)
			local ret = {}
			table.insert(ret, { item.text, "SnacksPickerLabel" })
			table.insert(ret, { string.rep(" ", 15 - #item.text) })
			for _, icon in ipairs(item.preview_icons) do
				table.insert(ret, icon)
			end
			return ret
		end,
		-- Correct way to handle live preview in Snacks
		preview = function(ctx)
			if ctx.item then
				M.apply_theme(ctx.item.value, true)

				-- Show some sample text in the right column to see the theme
				local lines = {
					" -- UI Theme: " .. ctx.item.value,
					" ",
					" local M = {} -- Module constant",
					" ",
					" -- Function definition with parameters",
					" function M.setup_ui(options)",
					"   local theme_name = 'gruvchad' -- String",
					"   local count = 42 -- Number",
					"   local is_enabled = true -- Boolean",
					" ",
					"   if options and is_enabled then",
					"     print('Applying ' .. theme_name) -- Function call",
					"   end",
					" ",
					"   return {",
					"     status = 'OK',",
					"     version = 1.0,",
					"   } -- Table with keys and values",
					" end",
					" ",
					" return M",
				}
				
				-- Ensure the buffer is valid and modifiable before modifying
				if vim.api.nvim_buf_is_valid(ctx.buf) then
					vim.bo[ctx.buf].modifiable = true
					vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, lines)
					vim.bo[ctx.buf].filetype = "lua"
					-- Disable some UI noise in the preview buffer
					vim.bo[ctx.buf].bufhidden = "wipe"
					vim.bo[ctx.buf].buftype = "nofile"
				end
			end
		end,
		confirm = function(picker, item)
			picker:close()
			if item then
				M.save_theme(item.value)
			end
		end,
		on_close = function()
			if _G.preview_theme then
				M.apply_theme(initial_theme, true)
				_G.preview_theme = nil
			end
		end,
	})
end

return M
