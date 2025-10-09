return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    {
      'aznhe21/actions-preview.nvim',
      config = function()
        require('actions-preview').setup({
          highlight_command = {
            require('actions-preview.highlight').delta(),
            require('actions-preview.highlight').diff_so_fancy(),
            require('actions-preview.highlight').diff_highlight(),
          },
        })
      end,
    },
    'nvimtools/none-ls.nvim',
    'simrat39/rust-tools.nvim',
    'hrsh7th/cmp-nvim-lsp',
    {
      'stevearc/conform.nvim',
      opts = {
        formatters = {
          mix = { args = { 'format', '-' } },
        },
        formatters_by_ft = {
          elixir = { 'mix' },
        },
      },
    },
  },
}
