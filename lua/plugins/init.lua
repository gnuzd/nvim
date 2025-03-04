return {
	"nvim-lua/plenary.nvim",

	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("catppuccin-mocha")
	-- 	end,
	-- },
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_transparent_background = 2
			vim.g.gruvbox_material_background = "soft"
			vim.cmd.colorscheme("gruvbox-material")
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "" })
		end,
	},

	"famiu/bufdelete.nvim",

	{
		"gnuzd/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = "*", -- set this if you want to always pull the latest change
		opts = function()
			return require("configs.code")
		end,
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"hrsh7th/nvim-cmp",
			"nvim-tree/nvim-web-devicons",
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},

	-- formatting!
	{
		"stevearc/conform.nvim",
		config = function()
			return require("configs.conform")
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
			current_line_blame = true,
		},
	},

	-- autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		version = false,
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
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

	-- lsp
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("configs.lsp")
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

	-- file managing , picker etc
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{ "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
		},
		opts = function()
			return require("configs.neotree")
		end,
	},

	{ "tadaa/vimade", opts = {} },

	-- fuzzy finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("configs.telescope")
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

	{
		"numToStr/Comment.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "JoosepAlviste/nvim-ts-context-commentstring" },
		event = "BufReadPre",
		config = function()
			local prehook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
			require("Comment").setup({ pre_hook = prehook })
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
		"folke/which-key.nvim",
		event = "VimEnter",
		keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
		cmd = "WhichKey",
		opts = {},
	},
}
