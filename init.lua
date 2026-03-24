-- Set leader key
vim.g.mapleader = " " -- You can use any key you like, but space is common

-- Faster loading
if vim.loader then
	vim.loader.enable()
end

-- Disable providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- This script will install lazy.nvim for you
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")
-- Now, run the lazy.nvim setup function
require("lazy").setup({
	spec = { import = "plugins" },
}, lazy_config)

require("options")

vim.schedule(function()
	require("mappings")
end)
