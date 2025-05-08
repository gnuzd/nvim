return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automaticaslly

	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_transparent_background = 2
			vim.g.gruvbox_material_background = "soft"
			vim.cmd.colorscheme("gruvbox-material")
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "" })
		end,
	},

	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		lazy = false,
		opts = function()
			return require("configs.code")
		end,
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-tree/nvim-web-devicons",
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},

	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {},
	},

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("configs.telescope")
		end,
	},

	-- LSP Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{
				"j-hui/fidget.nvim",
				opts = {
					progress = {
						ignore = { "null-ls" },
					},
				},
			},

			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("configs.lsp")
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		config = function()
			return require("configs.conform")
		end,
	},

	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		version = false,
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
					-- autopairing of (){}[] etcinit
					{
						"windwp/nvim-autopairs",
						opts = {
							fast_wrap = {
								map = "<M-e>",
								chars = { "{", "[", "(", '"', "'" },
								pattern = string.gsub([[ [%'%"%)%>%]%}%,] ]], "%s+", ""),
								offset = 0, -- Offset from pattern match
								end_key = "$",
								keys = "qwertzuiopasdfghjklxcvbnm",
								check_comma = true,
								highlight = "Search",
								highlight_grey = "Comment",
								enable_in_visualmode = true,
							},
							disable_filetype = { "TelescopePrompt", "vim" },
						},
						config = function(_, opts)
							require("nvim-autopairs").setup(opts)
							-- setup cmp for autopairs
							local cmp_autopairs = require("nvim-autopairs.completion.cmp")
							require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
						end,
					},
					"saadparwaiz1/cmp_luasnip",
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-path",
				},
			},
		},
		config = function()
			require("configs.cmp")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = function()
			return require("configs.treesitter")
		end,
	},

	{ -- Auto pairs
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{ -- Linting
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {}

			-- Create autocommand which carries out the actual linting
			-- on the specified events.
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- Only run the linter in buffers that you can modify in order to
					-- avoid superfluous noise, notably within the handy LSP pop-ups that
					-- describe the hovered symbol using Markdown.
					if vim.opt_local.modifiable:get() then
						lint.try_lint()
					end
				end,
			})
		end,
	},

	{
		"goolord/alpha-nvim",
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.buttons.val = {
				dashboard.button("e", "  New file", "<cmd>ene <CR>"),
				dashboard.button("SPC s f", "󰈞  Find file"),
				dashboard.button("SPC s g", "󰊄  Live grep"),
				dashboard.button("u", "  Update plugins", "<cmd>Lazy sync<CR>"),
				dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
			}

			return dashboard
		end,
		config = function(_, opts)
			require("alpha").setup(opts.config)
		end,
	},

	"famiu/bufdelete.nvim",

	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
		dependencies = { "davidmh/cspell.nvim" },
		opts = function(_, opts)
			local cspell = require("cspell")
			opts.sources = opts.sources or {}
			table.insert(
				opts.sources,
				cspell.diagnostics.with({
					diagnostics_postprocess = function(diagnostic)
						diagnostic.severity = vim.diagnostic.severity.HINT
					end,
				})
			)
			table.insert(opts.sources, cspell.code_actions)
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = "┊" },
			scope = { highlight = { "Normal" } },
		},
	},

	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("configs.oil")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		enabled = true,
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("configs.lualine")
		end,
	},

	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
	},

	{
		"folke/todo-comments.nvim",
		opts = { signs = false },
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			position = "right",
		},
	},

	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		config = function()
			require("configs.ufo")
		end,
	},

	{ "windwp/nvim-ts-autotag", opts = {} },
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	{ "rest-nvim/rest.nvim" },

	-- IMPORTANT: need to install this `brew install libpq`
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		keys = {
			{ "<leader>e", ":DBUIToggle <CR>", desc = "dbui toggle", silent = true },
		},

		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},

	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
			"neovim/nvim-lspconfig", -- optional
		},
		opts = {},
	},
}
