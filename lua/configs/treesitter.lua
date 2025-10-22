require("nvim-treesitter.configs").setup({
	ensure_installed = require("nvconfig").treesister.ensure_installed,
	auto_install = true,
	highlight = {
		enable = true,
		use_languagetree = true,
	},
	indent = { enable = true },
})
