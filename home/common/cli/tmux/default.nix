{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ tmux ];

  programs.alacritty.settings.keyboard.bindings =
    let
      mkBindWithPrefix = prefix: mods: key: char: {
        inherit key mods;
        chars = "${prefix}${char}";
      };
      mkBind = mkBindWithPrefix "\\u0002";
    in
    [
      # Move window
      (mkBind "Super|Shift" "<" "<")
      (mkBind "Super|Shift" ">" ">")

      # Resize pane
      (mkBind "Control|Shift" "h" "\\u001b[1;5D")
      (mkBind "Control|Shift" "j" "\\u001b[1;5B")
      (mkBind "Control|Shift" "k" "\\u001b[1;5A")
      (mkBind "Control|Shift" "l" "\\u001b[1;5C")

      # Force close pane
      (mkBind "Super" "w" "x")

      # Move between panes
      # https://github.com/alacritty/alacritty/issues/474#issuecomment-2137353585
      (mkBind "Super" "h" "\\u001b[D")
      (mkBind "Super" "j" "\\u001b[B")
      (mkBind "Super" "k" "\\u001b[A")
      (mkBind "Super" "l" "\\u001b[C")

      # Split pane H/V
      (mkBind "Control|Alt" "Return" "%")
      (mkBind "Control" "Return" "\"")

      # New/Previous/Next Window
      (mkBind "Super|Shift" "t" "c")
      (mkBind "Super|Shift" "h" "p")
      (mkBind "Super|Shift" "l" "n")
      (mkBind "Super|Shift" "q" "\\u0026")
    ];

  xdg.configFile."tmux/tmux.conf".text =
    let
      mkBind =
        { key, rest, ... }@attr:
        let
          comment = if attr ? comment then "# ${attr.comment}\n" else "";
          option = if attr ? option then "-${attr.option}" else null;
          table = if attr ? table then "-T ${attr.table}" else null;
          bind =
            [
              "bind"
              option
              table
              key
              rest
            ]
            |> (lib.filter builtins.isString)
            |> (lib.strings.concatStringsSep " ");
          unbind =
            [
              "unbind"
              table
              key
            ]
            |> (lib.filter builtins.isString)
            |> (lib.strings.concatStringsSep " ")

          ;
        in
        ''
          ${comment}${unbind}
          ${bind}
        '';
      bindings = lib.strings.concatMapStringsSep "\n" mkBind [
        {
          key = "r";
          rest = "source-file ~/.config/tmux/tmux.conf \\; display-message \"tmux conf reloaded\"";
        }
        {
          key = "'\"'";
          rest = "split-window -v -c \"#{pane_current_path}\"";
        }
        {
          key = "%";
          rest = "split-window -h -c \"#{pane_current_path}\"";
        }
        {
          key = "<";
          rest = "swap-window -dt -1";
        }
        {
          key = ">";
          rest = "swap-window -dt +1";
        }
        {
          key = "c";
          rest = "new-window -ac \"#{pane_current_path}\"";
        }
        {
          table = "copy-mode-vi";
          key = "DoubleClick1pane";
          rest = "send-keys -X select-word";
        }
        {
          table = "copy-mode-vi";
          key = "TripleClick1pane";
          rest = "send-keys -X select-line";
        }
        {
          comment = "Enter Visual selection with v";
          table = "copy-mode-vi";
          key = "v";
          rest = "send -X begin-selection";
        }
        {
          table = "copy-mode-vi";
          key = "y";
          rest = "send-keys -X copy-pipe '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'";
        }
        {
          table = "copy-mode-vi";
          key = "u";
          rest = "send-keys -X page-up \\; send-keys m";
        }
        {
          table = "copy-mode-vi";
          key = "d";
          rest = "send-keys -X page-down \\; send-keys m";
        }
      ];
    in
    ''
      if-shell -b "test \"$(gsettings2 get org.gnome.desktop.interface color-scheme)\" = \"'prefer-light'\"" {
        source-file ~/.config/tmux/light-theme.conf
      }

      if-shell -b "test \"$(gsettings2 get org.gnome.desktop.interface color-scheme)\" = \"'prefer-dark'\"" {
        source-file ~/.config/tmux/dark-theme.conf
      }

      if -F "#{==:#{session_windows},1}" "set -g status off" "set -g status on"
      set-hook -g window-linked 'if -F "#{==:#{session_windows},1}" "set -g status off" "set -g status on"'
      set-hook -g window-unlinked 'if -F "#{==:#{session_windows},1}" "set -g status off" "set -g status on"'

      set -g default-terminal "tmux-256color"
      set -as terminal-features ",alacritty*:RGB"
      set -g base-index 0
      setw -g pane-base-index 0

      set -g mouse on
      set -g status-key vi
      set -g mode-keys vi

      set -g focus-event on
      set -g aggressive-resize off
      set -g escape-time 0
      set -g history-limit 20000

      set -g status-left ""
      set -g status-right ""
      set -g status-style bg=default
      set -g status-position top
      setw -g window-status-current-format "#[reverse dim] #[nodim bold] #{pane_current_command} #{b:pane_path} #[dim] "
      setw -g window-status-format "#{?#{||:#{==:#I,0},#{==:#{e|-:#I,1},#{active_window_index}}},#{?#{==:#I,0},  ,},#[dim]| #[nodim]}#{pane_current_command} #{b:pane_path}"

      # Prevent jump to prompt once selected text is copied
      unbind -T copy-mode-vi MouseDragEnd1Pane

      ${bindings}
    '';
  xdg.configFile."tmux/light-theme.conf".text = ''
    set -g status-style fg=default
    set -g window-status-current-style 'fg=black'
    set -g window-status-style 'fg=black'
  '';

  xdg.configFile."tmux/dark-theme.conf".text = ''
    set -g pane-active-border-style "fg=#bf8300"
    set -g status-style fg=default
    set -g window-status-current-style 'fg=white'
    set -g window-status-style 'fg=white'
  '';

  switchTheme.hooks =
    let
      name = "switch-theme-tmux";
    in
    [
      (lib.getExe (
        pkgs.writeShellApplication {
          inherit name;
          runtimeInputs = [ pkgs.tmux ];
          text = ''
            tmux source-file "$HOME/.config/tmux/$1-theme.conf"
          '';
          meta.mainProgram = name;
        }
      ))
    ];
}
