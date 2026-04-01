local M = {}

M.formatters_by_ft = {
  lua = { "stylua" },
  css = { "prettier" },
  html = { "prettier" },
  typescript = { "prettierd", "prettier" },
  typescriptreact = { "prettierd", "prettier" },
  javascript = { "prettierd", "prettier" },
  javascriptreact = { "prettierd", "prettier" },
  graphql = { "prettierd", "prettier" },
}

local function get_formatter(ft)
  local formatters = M.formatters_by_ft[ft]
  if not formatters then return nil end
  
  for _, name in ipairs(formatters) do
    if vim.fn.executable(name) == 1 then
      return name
    end
  end
  return nil
end

function M.format()
  local bufnr = vim.api.nvim_get_current_buf()
  
  if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
    return
  end

  local ft = vim.bo.filetype
  local formatter = get_formatter(ft)

  if formatter then
    -- Use external formatter
    local view = vim.fn.winsaveview()
    vim.cmd("%!" .. formatter .. " --stdin-filepath " .. vim.fn.expand("%:p"))
    vim.fn.winrestview(view)
  else
    -- Fallback to LSP formatting
    vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 500 })
  end
end

-- Commands
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = "Disable autoformat-on-save", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = "Re-enable autoformat-on-save" })

-- Autocommand
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("UserFormatOnSave", { clear = true }),
  callback = function()
    M.format()
  end,
})

return M
