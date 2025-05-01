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
		cssls = {
			settings = {
				css = {
					lint = {
						unknownAtRules = "ignore",
					},
				},
			},
		},
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
	treesitter = {
		ensure_install = {
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"css",
			"graphql",
			"javascript",
			"typescript",
		},
	},
}
