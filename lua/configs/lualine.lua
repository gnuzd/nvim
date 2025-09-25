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
	},
})
