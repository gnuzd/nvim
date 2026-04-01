local api = vim.api

-- Function to setup tsserver
local function setup_tsserver()
  local root_dir = vim.fs.dirname(vim.fs.find({ 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }, { upward = true })[1])
  if root_dir then
    vim.lsp.start({
      name = 'tsserver',
      cmd = { 'typescript-language-server', '--stdio' },
      root_dir = root_dir,
      init_options = {
        hostInfo = 'neovim',
      },
    })
  end
end

-- Create an autocommand to start the server for typescript and javascript files
api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
  callback = function()
    setup_tsserver()
  end,
})

local icons = require('core.icons')

-- Diagnostic signs for the gutter
local signs = {
  Error = icons.Error,
  Warn = icons.Warn,
  Hint = icons.Hint,
  Info = icons.Info,
}

for type, icon in pairs(signs) do
  local name = "DiagnosticSign" .. type
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

-- Common LSP keymaps
api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Define common keymaps for all LSP clients
    local opts = { buffer = bufnr }
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Auto-completion as you type (built-in)
    local timer = nil
    api.nvim_create_autocmd('TextChangedI', {
      buffer = bufnr,
      callback = function()
        if timer then
          timer:stop()
          timer:close()
        end

        timer = vim.loop.new_timer()
        timer:start(150, 0, vim.schedule_wrap(function()
          local line = api.nvim_get_current_line()
          local cursor = api.nvim_win_get_cursor(0)
          local col = cursor[2]
          
          -- Trigger completion after characters or dots
          if col > 0 and line:sub(col, col):match('[%w%.]') and vim.fn.pumvisible() == 0 then
            local feedkey = api.nvim_replace_termcodes('<C-x><C-o>', true, false, true)
            api.nvim_feedkeys(feedkey, 'n', true)
          end
          
          if not timer:is_closing() then
            timer:close()
            timer = nil
          end
        end))
      end,
    })
  end,
})
