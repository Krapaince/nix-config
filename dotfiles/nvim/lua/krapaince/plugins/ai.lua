local function get_sse_port()
  local ok, cc = pcall(require, 'claudecode')
  if ok and cc.state and cc.state.port then
    return tostring(cc.state.port)
  end
  return nil
end

local function prompt_window_or_pane()
  local tmux_pane = vim.fn.getenv('TMUX_PANE')
  local width = 15
  local height = 4
  local tmp_file = vim.fn.system('mktemp --dry-run'):gsub('\n', '')

  local cmd = 'tmux display-popup '
    .. '-E -w '
    .. width
    .. ' -h '
    .. height
    .. ' '
    .. '-x "#{e|+|:#{pane_left},#{e|/|:#{e|-|:#{pane_width},'
    .. width
    .. '},2}}" '
    .. '-y "#{e|+|:#{pane_top},#{e|/|:#{e|-|:#{pane_height},'
    .. height
    .. '},2}}" '
    .. '-t '
    .. tmux_pane
    .. ' \'echo -e "pane\nwindow" | fzf --no-input > '
    .. tmp_file
    .. '\''

  vim.fn.system(cmd)

  vim.wait(5000, function()
    local stat = vim.uv.fs_stat(tmp_file)

    return stat ~= nil and stat.size > 0
  end, 100)

  local type = vim.fn.readfile(tmp_file)[1]

  vim.fn.delete(tmp_file)

  return type
end

local function attempt_to_retrieve_existing_claude()
  local claude = vim.g['claude']

  if type(claude) == 'table' then
    local cmd = 'tmux list-panes -aF \'#{pane_id} #{window_id}\' | grep -E \'^' .. claude.tmux_pane_id .. '\''
    local output = vim.fn.system(cmd)

    if output ~= '' then
      local tmux_window_id = vim.split(output, ' ')[2]
      if tmux_window_id ~= vim.g.claude.tmux_window_id then
        claude.tmux_window_id = tmux_window_id
        vim.g.claude = claude
      end
      return claude
    else
      vim.g.claude = nil
      return nil
    end
  else
    return nil
  end
end

local function open_claude()
  local tmux = vim.fn.getenv('TMUX')
  if tmux == vim.NIL or tmux == '' then
    vim.notify('Claude: not in a TMUX session', vim.log.levels.WARN)
    return nil
  end

  local claude = attempt_to_retrieve_existing_claude()

  if type(claude) == 'table' then
    return claude
  end

  local cwd = vim.fn.getcwd()
  local port = get_sse_port()
  local env_prefix = port and ('CLAUDE_CODE_SSE_PORT=' .. port .. ' ') or ''
  local cmd = ''
  local prompt = prompt_window_or_pane()
  if prompt == 'pane' then
    cmd = 'tmux split-window -h'
  elseif prompt == 'window' then
    cmd = 'tmux new-window -a'
  else
    return nil
  end

  cmd = cmd
    .. ' -PF "#{window_id} #{pane_id}" -c '
    .. vim.fn.shellescape(cwd)
    .. ' \''
    .. env_prefix
    .. 'claude --ide\''

  local tmux_window_id, tmux_pane_id = unpack(vim.split(vim.fn.system(cmd):gsub('\n', ''), ' '))
  claude = { tmux_window_id = tmux_window_id, tmux_pane_id = tmux_pane_id }
  vim.g['claude'] = claude
  return claude
end

local function get_claude()
  return vim.g['claude']
end

local function focus_claude_tmux()
  local claude = attempt_to_retrieve_existing_claude()

  if claude == nil then
    open_claude()
    return
  end

  vim.fn.system('tmux select-pane -t ' .. claude.tmux_pane_id)
  vim.fn.system('tmux select-window -t ' .. claude.tmux_window_id)
end

local function send_content_to_claude(content)
  local claude = get_claude()
  if claude == nil then
    claude = open_claude()

    if claude == nil then
      return
    end
  end

  if content ~= '' then
    vim.fn.system('tmux send-keys -t ' .. claude.tmux_pane_id .. ' ' .. content)
  end
end

local function send_file_to_claude()
  local filepath = vim.fn.expand('%:p')
  if filepath ~= '' then
    local content = '\'' .. vim.fn.shellescape('@' .. filepath) .. ' \''
    send_content_to_claude(content)
  end
  focus_claude_tmux()
end

local function send_selection_to_claude()
  local line1 = vim.fn.getpos('v')[2]
  local line2 = vim.fn.getpos('.')[2]
  local range = ''
  if line1 < line2 then
    range = line1 .. '-' .. line2
  else
    range = line2 .. '-' .. line1
  end

  local filepath = vim.fn.expand('%:p')
  if filepath ~= '' then
    local content = '\'' .. vim.fn.shellescape('@' .. filepath) .. '#L' .. range .. ' \''
    send_content_to_claude(content)
  end
  focus_claude_tmux()
end

return {
  {
    'coder/claudecode.nvim',
    opts = {
      auto_start = true,
      log_level = 'warn',
      track_selection = true,
      focus_after_send = false,
      terminal = {
        provider = 'none',
      },
      diff_opts = {
        enabled = false,
      },
    },
    config = function(_, opts)
      require('claudecode').setup(opts)

      vim.keymap.set('n', '<leader>a', send_file_to_claude)
      vim.keymap.set('x', '<leader>a', send_selection_to_claude)
      vim.keymap.set('n', '<leader>e', focus_claude_tmux)
    end,
  },
}
