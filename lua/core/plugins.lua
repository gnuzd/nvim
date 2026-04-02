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

require("lazy").setup({
  -- The Smooth Completion Engine
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      completion = {
        menu = {
          border = 'rounded',
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
          }
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 50,
          window = { border = 'rounded' }
        },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true, window = { border = 'rounded' } }
    },
    opts_extend = { "sources.default" }
  },

  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      
      -- Setup vtsls with blink capabilities
      lspconfig.vtsls.setup({
        capabilities = capabilities,
        settings = {
          typescript = {
            tsserver = { maxTsServerMemory = 8192 },
          },
          vtsls = {
            autoUseWorkspaceTsdk = true,
            experimental = { completion = { enableServerSideFuzzyMatch = true } },
          },
        },
      })

      -- You can add other servers here (lua_ls, etc.)
      lspconfig.lua_ls.setup({ capabilities = capabilities })
    end
  },
})
