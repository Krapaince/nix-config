local M = {}

M.setup = function(on_attach, capabilities)
  require('lspconfig').nixd.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      nixd = {
        nixpkgs = {
          expr = 'import <nixpkgs> { }',
        },
        formatting = {
          command = { 'nixfmt' },
        },
      },
    },
  })
end

return M
