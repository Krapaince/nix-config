local M = {}

M.on_attach = function(client, bufnr)
  require('krapaince.lsp.format').on_attach(client, bufnr)
  require('krapaince.lsp.keymaps').on_attach(client, bufnr)

  if client:supports_method('textDocument/documentSymbol', bufnr) then
    require('nvim-navic').attach(client, bufnr)
  end
end

return M
