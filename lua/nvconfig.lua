local M = {}

M.mason = {
	pks = { "stylua", "tree-sitter-cli", "prettierd", "tailwindcss" },
}

M.lsp = {
	elixirls = {},
	rust_analyzer = {},
	jsonls = {},
	vtsls = {},
	svelte = {},
	eslint_d = {},
	cssls = {},
	tailwindcss = {},
	-- solidity_ls_nomicfoundation = {},
	lua_ls = {
		settings = {
			Lua = {
				format = { enable = false },
				completion = {
					callSnippet = "Replace",
				},
				diagnostics = { disable = { "missing-fields" } },
			},
		},
	},
}

-- ensure basic parser are installed
M.treesister = {
	ensure_installed = {
		"bash",
		"c",
		"diff",
		"html",
		"lua",
		"luadoc",
		"markdown",
		"markdown_inline",
		"query",
		"vim",
		"vimdoc",
	},
}

return M
