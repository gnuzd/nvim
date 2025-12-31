local lualine = require("lualine")
lualine.setup({
	options = {
		theme = {
			normal = {
				a = { fg = "", bg = "" },
			},
		},
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
		lualine_y = { "progress" },
		lualine_z = { "location" },
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
