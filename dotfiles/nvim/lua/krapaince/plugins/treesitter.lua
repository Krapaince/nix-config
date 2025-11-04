-- https://github.com/chrisgrieser/.config/blob/62d76218e067f966c9e6ca1b46b0bfb81ee5fc90/nvim/lua/plugin-specs/appearance/treesitter.lua
local ensureInstalled = {
  programmingLangs = {
    'bash',
    'bibtex',
    'c',
    'cpp',
    'dockerfile',
    'elixir',
    'fish',
    'javascript',
    'latex',
    'lua',
    'nix',
    'python',
    'rust',
    'typescript',
  },
  dataFormats = {
    'json',
    'json5',
    'toml',
    'yaml',
  },
  content = {
    'css',
    'html',
    'markdown',
    'mermaid',
  },
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',

    init = function()
      vim.defer_fn(function()
        local alreadyInstalled = require('nvim-treesitter.config').get_installed()
        local parsersToInstall = vim
          .iter(vim.tbl_values(ensureInstalled))
          :flatten()
          :filter(function(parser)
            return not vim.tbl_contains(alreadyInstalled, parser)
          end)
          :totable()

        require('nvim-treesitter').install(parsersToInstall)
      end, 1000)
      require('nvim-treesitter').update()

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ctx)
          pcall(vim.treesitter.start, ctx.buf)
        end,
      })
    end,
  },
}
