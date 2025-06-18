local M = {}

M.setup = function(on_attach, capabilities)
  require('lspconfig').elixirls.setup({
    capabilities = capabilities,
    cmd = { 'elixir-ls' },
    on_attach = on_attach,
  })
end

return M
