return {
	lsp = {
		elixirls = {},
		svelte = {},
		-- rust_analyzer = {},
		jsonls = {},
		ts_ls = {},
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
		typos_lsp = {},
		lua_ls = {
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
					-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
					-- diagnostics = { disable = { 'missing-fields' } },
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
