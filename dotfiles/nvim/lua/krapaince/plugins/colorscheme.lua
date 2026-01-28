local vscFront = '#d4d4d4'
local vscDiffRedDark = '#4b1818'
local vscDiffGreenLight = '#4b5632'

return {
  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = false,
      group_overrides = {
        GitSignsAdd = { bg = vscDiffGreenLight, fg = vscFront },
        GitSignsChange = { bg = '#6F490B', fg = vscFront },
        GitSignsDelete = { bg = vscDiffRedDark, fg = vscFront },
      },
    },
    config = function(_, opts)
      local background = require('krapaince.utils').get_background()
      local user_opts = vim.tbl_extend('force', opts, { style = background })

      require('vscode').setup(user_opts)
      require('vscode').load()
    end,
    lazy = false,
  },
}
