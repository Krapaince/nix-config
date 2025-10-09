local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local library = vim.api.nvim_get_runtime_file('', true)
if vim.env.VIMRUNTIME then
  table.insert(library, vim.env.VIMRUNTIME)
end

return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim', 'use' },
      },
      format = {
        enable = false,
      },
      workspace = {
        -- https://github.com/neovim/nvim-lspconfig/issues/3189#issuecomment-3021345989
        library = vim.tbl_filter(function(d)
          return not d:match(vim.fn.stdpath('config') .. '/?a?f?t?e?r?')
        end, library),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
