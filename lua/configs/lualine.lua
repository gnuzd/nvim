require("lualine").setup({
	options = {
		component_separators = "|",
		section_separators = "",
		disabled_filetypes = { "toggleterm" },
		ignore_focus = { "neo-tree" },
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = {
			"encoding",
			"fileformat",
			"filetype",
		},
		lualine_y = {},
		lualine_z = {
			{
				function()
					local filepath = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
					return "󰉖 " .. filepath
				end,
			},
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})
