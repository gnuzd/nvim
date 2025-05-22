return {
	lsp = {
		elixirls = {},
		-- rust_analyzer = {},
		jsonls = {},
		ts_ls = {},
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
	},
	treesister = {
		ensure_installed = { "heex" },
	},
}
