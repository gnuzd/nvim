local M = {}

M.get_theme_colors = function()
	-- Prioritize the global preview_theme for real-time picker preview
	local theme = _G.preview_theme

	-- If no preview, try to load from persisted state
	if not theme then
		local status, state = pcall(require, "theme_state")
		if status and state.theme then
			theme = state.theme
		else
			-- Fallback to nvconfig
			local ok_cfg, cfg = pcall(require, "nvconfig")
			if ok_cfg and cfg.ui and cfg.ui.theme then
				theme = cfg.ui.theme
			else
				theme = "gruvbox" -- Final fallback
			end
		end
	end

	local ok, theme_mod = pcall(require, "themes.schemes." .. theme)
	if not ok then
		-- Absolute fallback if the theme file is missing
		return require("themes.schemes.gruvbox").colors
	end

	return theme_mod.colors
end

return M
