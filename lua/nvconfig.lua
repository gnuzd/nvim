return {
	lsp = {
		elixirls = {},
		-- rust_analyzer = {},
		jsonls = {},
		ts_ls = {},
		svelte = {},
		eslint_d = {},
		prettierd = {},
		-- solidity_ls_nomicfoundation = {},
		tailwindcss = {},
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
	mason = {
		pkgs = { "lua_ls" },
	},
	treesitter = {
		ensure_install = {
			"lua",
			"luadoc",
			"printf",
			"vim",
			"vimdoc",
			"graphql",
			"javascript",
			"typescript",
		},
	},
}
