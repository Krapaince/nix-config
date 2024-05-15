local M = {}

M.setup = function(on_attach, capabilities)
  require('lspconfig').nil_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
          ['nil'] = {
              formatting = {
                  command = { "nixfmt" }
              }
          }
      }
  })
end

return M
