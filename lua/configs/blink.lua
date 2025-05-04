return {
	keymap = {
		preset = "enter",
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
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
			winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
			draw = {
				columns = {
					{ "label", "label_description" },
					{ "kind_icon", "kind", gap = 2 },
				},
			},
		},
		documentation = { window = { border = "rounded" }, auto_show = true, auto_show_delay_ms = 500 },
	},

	sources = {
		default = { "lsp", "path", "snippets", "lazydev" },
		providers = {
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
			border = "rounded",
			winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
		},
	},
}
