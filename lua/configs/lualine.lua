local lualine = require("lualine")
local colors = require("themes").get_theme_colors()
local icons = require("configs.icons")

local theme = {
	normal = {
		a = { fg = colors.black, bg = colors.blue, gui = "bold" },
		b = { fg = colors.white, bg = colors.one_bg },
		c = { fg = colors.white, bg = colors.statusline_bg },
	},
	insert = {
		a = { fg = colors.black, bg = colors.green, gui = "bold" },
	},
	visual = {
		a = { fg = colors.black, bg = colors.purple, gui = "bold" },
	},
	replace = {
		a = { fg = colors.black, bg = colors.red, gui = "bold" },
	},
	command = {
		a = { fg = colors.black, bg = colors.yellow, gui = "bold" },
	},
	inactive = {
		a = { fg = colors.grey, bg = colors.black, gui = "bold" },
		b = { fg = colors.grey, bg = colors.black },
		c = { fg = colors.grey, bg = colors.black },
	},
}

local function get_lsp_client()
	local msg = "No Active LSP"
	local buf_ft = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_active_clients({ bufnr = buf_ft })
	if next(clients) == nil then
		return msg
	end
	local client_names = {}
	for _, client in ipairs(clients) do
		table.insert(client_names, client.name)
	end
	return " " .. table.concat(client_names, ", ")
end

lualine.setup({
	options = {
		theme = theme,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "toggleterm", "NvimTree" },
		ignore_focus = {},
		globalstatus = true,
	},
	sections = {
		lualine_a = {
			{
				function()
					return ""
				end,
				padding = { left = 1, right = 0 },
			},
			{
				"mode",
				padding = { left = 1, right = 1 },
			},
		},
		lualine_b = {
			{
				"filetype",
				icon_only = true,
				colored = true,
				padding = { left = 2, right = 0 },
			},
			{
				"filename",
				file_status = true,
				path = 0,
				padding = { left = 1, right = 1 },
			},
			{
				"branch",
				icon = "",
				padding = { left = 1, right = 1 },
			},
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = {
					error = icons.Error,
					warn = icons.Warn,
					info = icons.Info,
					hint = icons.Hint,
				},
				padding = { left = 1, right = 1 },
			},
		},
		lualine_c = {},
		lualine_x = {
			{
				"diff",
				symbols = {
					added = icons.Added,
					modified = icons.Modified,
					removed = icons.Removed,
				},
				padding = { left = 1, right = 1 },
			},
			{
				function()
					return "|"
				end,
				color = { fg = colors.grey },
			},
			{
				function()
					local line = vim.fn.line(".")
					local col = vim.fn.virtcol(".")
					return string.format("Ln %d, Col %d", line, col)
				end,
				padding = { left = 1, right = 1 },
			},
			{
				"encoding",
				padding = { left = 1, right = 1 },
			},
		},
		lualine_y = {
			{
				get_lsp_client,
				padding = { left = 1, right = 1 },
				color = { fg = colors.green },
			},
		},
		lualine_z = {
			{
				function()
					return icons.Folder .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				end,
				color = { fg = colors.black, bg = colors.blue, gui = "bold" },
				padding = { left = 1, right = 1 },
			},
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
})
