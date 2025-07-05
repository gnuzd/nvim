require("nvchad.configs.lspconfig").defaults()

-- local servers = { "html", "cssls", "jsonls", "typescript-language-server", "svelte", "eslint_d" }
-- vim.lsp.enable(servers)

local servers = {
  html = {},
	jsonls = {},
		ts_ls = {},
		svelte = {},
		eslint_d = {},
		cssls = {},

}

for name, opts in pairs(servers) do
  vim.lsp.enable(name)  
  vim.lsp.config(name, opts)
end
-- read :h vim.lsp.config for changing options of lsp servers 
