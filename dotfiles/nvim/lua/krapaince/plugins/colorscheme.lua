return {
  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = false,
    },
    config = function(_, opts)
      local background = require('krapaince.utils').get_background()
      local user_opts = vim.tbl_extend('force', opts, {style = background})

      require('vscode').setup(user_opts)
      require('vscode').load()
    end,
    lazy = false,
  },
}
