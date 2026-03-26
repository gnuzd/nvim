local lualine = require("lualine")
local colors = require("themes").get_theme_colors()
local icons = require("configs.icons")

local theme = {
	normal = {
		a = { fg = colors.blue, bg = colors.black2, gui = "bold" },
		b = { fg = colors.white, bg = colors.black2 },
		c = { fg = colors.white, bg = colors.black2 },
	},
	insert = {
		a = { fg = colors.green, bg = colors.black2, gui = "bold" },
	},
	visual = {
		a = { fg = colors.purple, bg = colors.black2, gui = "bold" },
	},
	replace = {
		a = { fg = colors.red, bg = colors.black2, gui = "bold" },
	},
	command = {
		a = { fg = colors.yellow, bg = colors.black2, gui = "bold" },
	},
	inactive = {
		a = { fg = colors.grey, bg = colors.black2, gui = "bold" },
		b = { fg = colors.grey, bg = colors.black2 },
		c = { fg = colors.grey, bg = colors.black2 },
	},
}

local function get_lsp_client()
	local buf_ft = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = buf_ft })
	if next(clients) == nil then
		return "No Active LSP"
	end
	local client_names = {}
	for _, client in ipairs(clients) do
		table.insert(client_names, client.name)
	end
	return "✔ " .. table.concat(client_names, ", ")
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
				file_status = false, -- Matches screenshot: just the name
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
					error = " ",
					warn = " ",
					info = " ",
					hint = "󰌵 ",
				},
				padding = { left = 1, right = 1 },
			},
		},
		lualine_c = {},
		lualine_x = {
			{
				"diff",
				symbols = {
					added = " ",
					modified = " ",
					removed = " ",
				},
				padding = { left = 1, right = 1 },
			},
			{
				function()
					return "|"
				end,
				color = { fg = colors.grey },
				padding = { left = 1, right = 1 },
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
				color = { fg = colors.red }, -- Matches screenshot: pinkish-red
			},
			{
				function()
					local ft = vim.bo.filetype
					if ft == "" then return "" end
					return "{} " .. ft
				end,
				padding = { left = 1, right = 1 },
				color = { fg = colors.blue }, -- Matches screenshot: blue
			},
			{
				get_lsp_client,
				padding = { left = 1, right = 1 },
				color = { fg = colors.green }, -- Matches screenshot: green
			},
		},
		lualine_y = {},
		lualine_z = {
			{
				function()
					return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
				end,
				color = { fg = colors.red, bg = colors.black2, gui = "bold" },
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
