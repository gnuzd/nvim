local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- general
map("n", "<leader>n", "<cmd> enew <cr>", { desc = "general new buffer" })
map("n", "<tab>", "<cmd> bnex <cr>", { desc = "general next buffer" })
map("n", "<S-tab>", "<cmd> bprevious <cr>", { desc = "general prev buffer" })
map("n", "<C-s>", "<cmd> w <cr>", { desc = "general save buffer" })
map("n", "<C-a>", "ggVG", { desc = "general select all" })
map("n", "D", vim.diagnostic.open_float, { desc = "general show diagnostic error messages" })
map("n", "<Esc>", "<cmd>noh<cr>", { desc = "general clear highligh" })
map("i", "jj", "<Esc>", { desc = "general clear highligh" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map({ "n", "v" }, "<PageUp>", "^", { desc = "move to beginning of line" })
map("i", "<PageUp>", "<ESC>^", { desc = "move to beginning of line" })

-- snacks
-- -- Top Pickers & explorer
map("n", "\\", "<cmd>lua Snacks.explorer() <cr>", { desc = "[Snacks] File Explorer" })

-- -- find
map("n", "<leader>fb", "<cmd>lua Snacks.picker.buffers() <cr>", { desc = "[Snacks] Find Buffers" })
map("n", "<leader>ff", "<cmd>lua Snacks.picker.files() <cr>", { desc = "[Snacks] Find Files" })
map("n", "<leader>fg", "<cmd>lua Snacks.picker.git_files() <cr>", { desc = "[Snacks] Find Git Files" })
map("n", "<leader>fp", "<cmd>lua Snacks.picker.projects() <cr>", { desc = "[Snacks] Projects" })
map("n", "<leader>fr", "<cmd>lua Snacks.picker.recent() <cr>", { desc = "[Snacks] Recent" })

-- git
map("n", "<leader>gb", "<cmd>lua Snacks.picker.git_branches() <cr>", { desc = "[Snacks] Git Branches" })
map("n", "<leader>gl", "<cmd>lua Snacks.picker.git_log() <cr>", { desc = "[Snacks] Git Log" })
map("n", "<leader>gL", "<cmd>lua Snacks.picker.git_log_line() <cr>", { desc = "[Snacks] Git Log Line" })
map("n", "<leader>gs", "<cmd>lua Snacks.picker.git_status() <cr>", { desc = "[Snacks] Git Status" })
map("n", "<leader>gS", "<cmd>lua Snacks.picker.git_stash() <cr>", { desc = "[Snacks] Git Stash" })
map("n", "<leader>gd", "<cmd>lua Snacks.picker.git_diff() <cr>", { desc = "[Snacks] Git Diff (Hunks)" })
map("n", "<leader>gf", "<cmd>lua Snacks.picker.git_log_file() <cr>", { desc = "[Snacks] Git Log File" })

-- Grep
map("n", "<leader>sb", "<cmd>lua Snacks.picker.lines() <cr>", { desc = "[Snacks] Buffer Lines" })
map("n", "<leader>sB", "<cmd>lua Snacks.picker.grep_buffers() <cr>", { desc = "[Snacks] Grep Open Buffers" })
map("n", "<leader>sg", "<cmd>lua Snacks.picker.grep() <cr>", { desc = "[Snacks] Grep" })

map("n", "<leader>sw", "<cmd>lua Snacks.picker.grep_word()<cr>", { desc = "[Snacks] Visual selection or word" })
map("x", "<leader>sw", "<cmd>lua Snacks.picker.grep_word()<cr>", { desc = "[Snacks] Visual selection or word" })

-- LSP
map("n", "gd", "<cmd>lua Snacks.picker.lsp_definitions() <cr>", { desc = "[Snacks] Goto Definition" })
map("n", "gD", "<cmd>lua Snacks.picker.lsp_declarations() <cr>", { desc = "[Snacks] Goto Declaration" })
map("n", "gr", "<cmd>lua Snacks.picker.lsp_references() <cr>", { nowait = true, desc = "[Snacks] References" })
map("n", "gI", "<cmd>lua Snacks.picker.lsp_implementations() <cr>", { desc = "[Snacks] Goto Implementation" })
map("n", "gy", "<cmd>lua Snacks.picker.lsp_type_definitions() <cr>", { desc = "[Snacks] Goto T[y]pe Definition" })
map("n", "<leader>ss", "<cmd>lua Snacks.picker.lsp_symbols() <cr>", { desc = "[Snacks] LSP Symbols" })
map(
	"n",
	"<leader>sS",
	"<cmd>lua Snacks.picker.lsp_workspace_symbols() <cr>",
	{ desc = "[Snacks] LSP Workspace Symbols" }
)

-- others
map("n", "<leader>z", "<cmd>lua Snacks.zen() <cr>", { desc = " [Snacks] Toggle Zen Mode" })
map("n", "<leader>.", "<cmd>lua Snacks.scratch() <cr>", { desc = " [Snacks] Toggle Scratch Buffer" })
map("n", "<leader>cr", "<cmd>lua Snacks.rename.rename_file() <cr>", { desc = " [Snacks] Rename File" })
map("n", "<leader>x", "<cmd>lua Snacks.bufdelete() <cr>", { desc = " [Snacks] Delete Buffer" })
map("n", "<leader>th", "<cmd>lua Snacks.picker.colorschemes() <cr>", { desc = " [Snacks] Pick Colorschemes" })
map({ "n", "v" }, "<leader>gB", "<cmd>lua Snacks.gitbrowse() <cr>", { desc = " [Snacks] Git Browse" })

-- conform
map("n", "<leader>b", function()
	if vim.g.disable_autoformat then
		vim.cmd("FormatEnable")
	else
		vim.cmd("FormatDisable")
	end
end, { desc = "general toggle format on save" })

-- comment
map("n", "<leader>/", "gcc", { desc = "comment or uncomment", remap = true })
map("v", "<leader>/", "gc", { desc = "comment or uncomment", remap = true })

-- gitsigns
map("n", "<leader>bl", "<cmd> Gitsigns blame_line <cr>", { desc = "[Gitsigns] Blame line" })

-- telescope
-- map("n", "<leader><space>", "<cmd> Telescope buffers <cr>", { desc = "telescope find buffers" })
-- map("n", "<leader>sf", "<cmd> Telescope find_files <cr>", { desc = "telescope find files" })
-- map("n", "<leader>sg", "<cmd> Telescope live_grep <cr>", { desc = "telescope live grep" })

-- trouble
map("n", "<leader>st", "<cmd> Trouble diagnostics <cr>", { desc = "[Trouble] diagnostics loclist" })
map("n", "<leader>sd", "<cmd> Trouble todo <cr>", { desc = "[Trouble] Todo" })

-- whichkey
map("n", "<leader>wK", "<cmd> WhichKey <cr>", { desc = "[Whichkey] All Keymaps" })
map("n", "<leader>wk", function()
	vim.cmd("Whichkey " .. vim.fn.input("WhichKey: "))
end, { desc = "[Whichkey] query lookup" })
