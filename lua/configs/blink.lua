return {
	keymap = {
		preset = "enter",
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<C-k>"] = { "scroll_documentation_up", "fallback" },
		["<C-j>"] = { "scroll_documentation_down", "fallback" },
	},

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	completion = {
		list = {
			selection = {
				preselect = true,
				auto_insert = true,
			},
		},
		menu = {
			border = "rounded",
			scrollbar = false,
			winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
			draw = {
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 2 },
					{ "kind" },
				},
			},
		},
		documentation = { window = { border = "rounded" }, auto_show = true, auto_show_delay_ms = 500 },
	},

	sources = {
		default = { "avante", "lsp", "path", "snippets", "lazydev" },
		providers = {
			avante = {
				module = "blink-cmp-avante",
				name = "Avante",
				opts = {},
			},
			lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
		},
	},

	snippets = { preset = "luasnip" },

	-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
	-- which automatically downloads a prebuilt binary when enabled.
	--
	-- By default, we use the Lua implementation instead, but you may enable
	-- the rust implementation via `'prefer_rust_with_warning'`
	--
	-- See :h blink-cmp-config-fuzzy for more information
	fuzzy = { sorts = { "exact", "kind", "label" }, implementation = "lua" },

	-- Shows a signature help window while you type arguments for a function
	signature = {
		enabled = true,
		window = {
			scrollbar = false,
			border = "rounded",
			winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
		},
	},
}
