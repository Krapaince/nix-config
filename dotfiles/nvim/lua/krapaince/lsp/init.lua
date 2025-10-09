local null_ls = require('null-ls')
local b = null_ls.builtins
local sources = {
  b.diagnostics.actionlint,
  b.formatting.black,
  b.formatting.prettierd,
  b.formatting.stylua,
}

local on_attach = require('krapaince.lsp.config').on_attach

null_ls.setup({ debug = false, on_attach = on_attach, sources = sources })

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  root_markers = { '.git' },
  on_attach = on_attach,
})

vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          command = 'clippy',
        },
        cargo = {
          autoreload = true,
        },
        diagnostics = {
          enable = true,
          disabled = {},
          enableExperimental = true,
        },
      },
    },
  },
}

vim.lsp.enable({
  'bashls',
  'clangd',
  'cssls',
  'dockerls',
  'elixirls',
  'erlangls',
  'eslint',
  'html',
  'jsonls',
  'lemminx',
  'lua_ls',
  'nixd',
  'pyright',
  'texlab',
  'ts_ls',
  'yamlls',
})
