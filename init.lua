-- Set leader key
vim.g.mapleader = " " -- You can use any key you like, but space is common

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
