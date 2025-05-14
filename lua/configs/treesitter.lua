-- local ensure_installed = require("nvconfig").treesitter.ensure_installed
return {
	-- ensure_installed = ensure_installed,
	auto_install = true,
	highlight = {
		enable = true,
		use_languagetree = true,
	},

	indent = { enable = true },
}
