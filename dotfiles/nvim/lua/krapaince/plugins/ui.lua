return {
  {
    'hoob3rt/lualine.nvim',
    opts = function()
      local colors = require('vscode.colors').get_colors()

      local diag_icons = require('krapaince.config.init').icons.diagnostics
      local diagnostics = {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        color_error = colors.vscRed,
        color_warn = colors.vscOrange,
        color_info = colors.vscYellow,
        color_hint = colors.vscFront,
        symbols = {
          error = diag_icons.Error .. ' ',
          warn = diag_icons.Warn .. ' ',
          info = diag_icons.Hint .. ' ',
          hint = diag_icons.Info .. ' ',
        },
      }

      local winbar_filename = {
        'filename',
        path = 1,
        shorting_target = 20,
      }

      local navic = require('nvim-navic')
      return {
        tabline = {
          lualine_a = {
            'tabs',
          },
        },
        winbar = { lualine_c = { winbar_filename } },
        inactive_winbar = { lualine_c = { winbar_filename } },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', diagnostics },
          lualine_c = {
            'filename',
            {
              function()
                return navic.get_location()
              end,
              cond = function()
                return navic.is_available()
              end,
            },
          },
          lualine_x = { 'encoding', 'fileformat' },
          lualine_y = { 'filetype' },
          lualine_z = { 'location', 'progress' },
        },
        options = {
          theme = 'vscode-custom',
          disabled_filetypes = { 'packer', 'neo-tree' },
          ignore_focus = { 'neo-tree' },
          globalstatus = true,
        },
        extensions = {},
      }
    end,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      {
        'SmiteshP/nvim-navic',
        dependencies = 'neovim/nvim-lspconfig',
        opts = function()
          local icons = require('krapaince.config.init').icons.kinds

          return { icons = icons }
        end,
      },
    },
  },

  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- {%@@ if profile != "krapaince_min" @@%}

  { 'norcalli/nvim-colorizer.lua', opts = { '*' } },

  { 'luukvbaal/stabilize.nvim' },

  -- {%@@ endif @@%}
  --
}
