local M = {}

M.mason = {
	pks = { "stylua", "tree-sitter-cli", "prettierd", "tailwindcss" },
}

M.lsp = {
	-- elixirls = {},
	-- rust_analyzer = {},
	jsonls = {},
	vtsls = {},
	svelte = {},
	eslint_d = {},
	cssls = {},
	-- solidity_ls_nomicfoundation = {},
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				diagnostics = { disable = { "missing-fields" } },
			},
		},
	},
}

M.treesister = {
	ensure_installed = {},
}

return M
