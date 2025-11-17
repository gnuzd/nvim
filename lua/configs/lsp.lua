local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
M.on_attach = function(event)
	local function opts(desc)
		return { buffer = event.buf, desc = "LSP " .. desc }
	end

	map("n", "K", function()
		vim.lsp.buf.hover({ border = "rounded", max_height = 50, max_width = 120 })
	end, opts("hover document"))

	map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, opts("code action"))

	local client = vim.lsp.get_client_by_id(event.data.client_id)
	if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
		local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = event.buf,
			group = highlight_augroup,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = event.buf,
			group = highlight_augroup,
			callback = vim.lsp.buf.clear_references,
		})

		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
			callback = function(event2)
				vim.lsp.buf.clear_references()
				vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
			end,
		})
	end

	-- The following code creates a keymap to toggle inlay hints in your
	-- code, if the language server you are using supports them
	--
	-- This may be unwanted, since they displace some of your code
	if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
		map("n", "<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, opts("toggle inlay hints"))
	end
end

-- disable semanticTokens
M.on_init = function(client, _)
	if client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

M.capabilities = vim.tbl_deep_extend(
	"force",
	vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities()
)

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

M.diagnostic_config = function()
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

	vim.diagnostic.config({
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = vim.diagnostic.severity.ERROR },
		signs = vim.g.have_nerd_font and {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			},
		} or {},
		virtual_text = {
			source = "if_many",
			spacing = 2,
			format = function(diagnostic)
				local diagnostic_message = {
					[vim.diagnostic.severity.ERROR] = diagnostic.message,
					[vim.diagnostic.severity.WARN] = diagnostic.message,
					[vim.diagnostic.severity.INFO] = diagnostic.message,
					[vim.diagnostic.severity.HINT] = diagnostic.message,
				}
				return diagnostic_message[diagnostic.severity]
			end,
		},
	})
end

M.setup = function()
	M.diagnostic_config()

	local cfg = require("nvconfig")

	require("mason").setup()
	local servers = cfg.lsp
	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, cfg.mason.pks)
	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
		callback = function(event)
			M.on_attach(event)
		end,
	})

	vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
	for key, value in pairs(servers) do
		vim.lsp.config(key, value)
	end

	require("mason-lspconfig").setup({
		ensure_installed = {},
	})
end

return M
