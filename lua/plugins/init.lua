return {
	"nvim-lua/plenary.nvim",

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

	"folke/which-key.nvim",

	{ -- formatting!
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = require("configs.conform"),
	},

	{ -- git stuff
		"lewis6991/gitsigns.nvim",
		opts = require("configs.gitsigns"),
	},

	-- nvim-lspconfig and cmp configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("configs.lsp").setup()
		end,
	},

	-- nvim-cmp for autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- Load only when entering Insert mode
		dependencies = {
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opts = { history = true, updateevents = "TextChanged,TextChangedI" },
				config = function(_, opts)
					require("luasnip").config.set_config(opts)
					require("configs.luasnip")
				end,
			},

			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"onsails/lspkind.nvim",

			{
				"jdrupal-dev/css-vars.nvim",
				opts = {
					cmp_filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"css",
						"svelte",
					},
					search_pattern = {
						default = [[^\s*--[a-zA-Z0-9_-]+]],
						css = [[^\s*--[a-zA-Z0-9_-]+]],
						svelte = [[^\s*--[a-zA-Z0-9_-]+]],
					},
					-- Explicitly tell the plugin to search in .svelte files
					search_extensions = {
						".css",
						".svelte",
					},
				},
			},

			{
				"Jezda1337/nvim-html-css",
				dependencies = { "nvim-treesitter/nvim-treesitter" },
			},
		},
		opts = function()
			return require("configs.cmp")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufEnter",
		build = ":TSUpdate",
		branch = "master",
		config = function()
			return require("configs.treesitter")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("configs.lualine")
		end,
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
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown" },
		},
		ft = { "markdown" },
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	{
		"folke/snacks.nvim",
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			explorer = { enabled = true },
			indent = { enabled = true, char = "┊" },
			input = { enabled = true },
			picker = {
				enabled = true,
				win = {
					input = {
						keys = {
							["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
							["<Tab>"] = { "list_down", mode = { "i", "n" } },
						},
					},
					list = {
						keys = {
							["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
							["<Tab>"] = { "list_down", mode = { "i", "n" } },
						},
					},
				},
			},
			notifier = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
	},

	-- mini
	{
		"nvim-mini/mini.nvim",
		version = "*",
		config = function()
			require("mini.ai").setup({})
			require("mini.comment").setup({})
			require("mini.diff").setup({})
			require("mini.pairs").setup({})
		end,
	},

	-- The auto-tagging plugin
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
