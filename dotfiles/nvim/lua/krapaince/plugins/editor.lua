local utils = require('krapaince.utils')
local colors = require('vscode.colors').get_colors()

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    cmd = 'Neotree',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
      { 'MunifTanjim/nui.nvim' },
      {
        's1n7ax/nvim-window-picker',
        tag = 'v1.5',
        opts = function()
          return {
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              bo = {
                filetype = { 'neo-tree', 'neo-tree-popup', 'notify', 'Trouble' },
                buftype = { 'terminal', 'quickfix' },
              },
            },
            fg_color = colors.vscBlue,
            other_win_hl_color = colors.vscLeftMid,
          }
        end,
      },
    },
    keys = {
      { '<Leader>t', '<cmd>Neotree toggle<CR>' },
    },
    opts = {
      window = {
        mappings = {
          ['o'] = 'open_with_window_picker',
        },
      },
      default_component_configs = {
        indent = {
          with_markers = false,
        },
        name = {
          use_git_status_colors = false,
        },
        git_status = {
          symbols = require('krapaince.config.init').icons.git,
        },
      },
    },
  },

  -- {%@@ if profile != "krapaince_min" @@%}

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
    keys = {
      { '<C-s>', '<cmd>Telescope lsp_document_symbols<CR>' },
      { '<C-f>', '<cmd>Telescope current_buffer_fuzzy_find<CR>' },
    },
    opts = function()
      local actions = require('telescope.actions')

      return {
        defaults = {
          prompt_prefix = '   ',
          selection_caret = ' ',
          entry_prefix = ' ',
          sorting_strategy = 'ascending',
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.80,
            height = 0.85,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<esc>'] = actions.close,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
          },
        },
        file_ignore_patterns = {
          'nodes_modules/.*',
          '.git/.*',
          'target/.*',
          '.yarn',
        },
      }
    end,
  },
  {
    'dmtrKovalenko/fff.nvim',
    build = 'nix run .#release',
    opts = {
      layout = {
        prompt_position = 'top',
      },
      prompt = '> ',
      keymaps = {
        move_up = { '<C-k>' },
        move_down = { '<C-j>' },
      },
      grep = {
        modes = { 'fuzzy', 'regex', 'plain' },
      },
    },
    lazy = false,
    keys = {
      {
        '<C-p>',
        function()
          require('fff').find_files()
        end,
        desc = 'FFFind files',
      },
      {
        '/',
        function()
          require('fff').live_grep()
        end,
        desc = 'Live fffuzy grep',
      },
      {
        '/',
        function()
          vim.cmd('noau normal! "zy"')
          local query = vim.fn.getreg('z')
          vim.fn.setreg('z', {})

          query = string.gsub(query, '\n', '')

          if string.len(query) == 0 then
            query = ''
          end

          require('fff').live_grep({ query = query, grep = { modes = { 'plain', 'fuzzy', 'regex' } } })
        end,
        mode = { 'v' },
      },
    },
  },

  { 'tpope/vim-fugitive' },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      signcolumn = false,
      numhl = true,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local buf_map = require('krapaince.utils').buf_map

        buf_map(bufnr, 'n', '<leader>g', function()
          gs.blame_line({ full = true })
        end)
      end,
    },
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install && git restore .',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },

  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = {
          icon = ' ',
          color = 'error',
          alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
        },
        TODO = { icon = ' ', color = 'info' },
        HACK = { icon = ' ', color = 'warning' },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        PERF = { icon = '󰅒 ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { icon = '󰍨 ', color = 'hint', alt = { 'INFO' } },
      },
      merge_keywords = true,
      highlight = {
        before = '',
        keyword = 'wide',
        after = 'fg',
        pattern = [[.*<(KEYWORDS)\s*]],
        comments_only = true,
        max_line_len = 400,
      },
      colors = {
        error = { 'LspDiagnosticsDefaultError', 'ErrorMsg', colors.vscRed },
        warning = { 'LspDiagnosticsDefaultWarning', 'WarningMsg', colors.vscDarkYellow },
        info = { 'LspDiagnosticsDefaultInformation', colors.vscMediumBlue },
        hint = { 'LspDiagnosticsDefaultHint', colors.vscBlueGreen },
        default = { 'Identifier', colors.vscGray },
      },
      search = {
        command = 'rg',
        args = {
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
        },
        pattern = [[\b(KEYWORDS)]], -- ripgrep regex
      },
    },
  },

  {
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      use_diagnostic_signs = true,
    },
  },

  {
    'chrisgrieser/nvim-origami',
    event = 'VeryLazy',
    opts = {
      autoFold = { enabled = false },
    },
  },

  {
    'michaelrommel/nvim-silicon',
    lazy = true,
    cmd = 'Silicon',
    opts = {
      font = 'Iosevka Term Extended',
      theme = 'Visual Studio Dark+',
      pad_horiz = 0,
      pad_vert = 0,
      no_window_controls = true,
      tab_width = 2,
      to_clipboard = true,
    },
  },

  { 'junegunn/vim-easy-align' },
  { 'wesQ3/vim-windowswap' },

  -- {%@@ endif @@%}

  {
    'ntpeters/vim-better-whitespace',
    event = 'BufReadPre',
    keys = {
      { '<leader><Space>', '<cmd>StripWhitespace<CR>' },
    },
  },
}
