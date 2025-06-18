local null_ls = require('null-ls')
local b = null_ls.builtins

local sources = {
  b.diagnostics.actionlint,
  function()
    local nl_utils = require('null-ls.utils').make_conditional_utils()

    if nl_utils.root_has_file({ '.prettierrc.json', '.prettierrc' }) then
      return b.formatting.prettierd.with({ filetypes = { 'html', 'javascript', 'typescript', 'svelte' } })
    else
      return b.formatting.eslint_d
    end
  end,
  b.formatting.black,
  b.formatting.stylua,
}

local M = {}

M.setup = function(on_attach)
  null_ls.setup({
    debug = false,
    sources = sources,
    on_attach = on_attach,
  })
end

return M
