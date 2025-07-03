require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<C-a>", "ggVG", { desc = "general select all" })
map({ "n", "v" }, "<PageUp>", "^", { desc = "move to beginning of line" })
map("i", "<PageUp>", "<ESC>^", { desc = "move to beginning of line" })
map({ "n", "v" }, "<PageUp>", "^", { desc = "move to beginning of line" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "\\", "<cmd>NvimTreeFocus<CR>")

-- telescope
map("n", "<leader><space>", "<cmd> Telescope buffers <cr>", { desc = "telescope find buffers" })
map("n", "<leader>sf", "<cmd> Telescope find_files <cr>", { desc = "telescope find files" })
map("n", "<leader>sg", "<cmd> Telescope live_grep <cr>", { desc = "telescope live grep" })

-- trouble
map("n", "<leader>ss", "<cmd> Trouble diagnostics <cr>", { desc = "trouble diagnostics loclist" })
map("n", "<leader>sd", "<cmd> Trouble todo <cr>", { desc = "trouble todo" })

