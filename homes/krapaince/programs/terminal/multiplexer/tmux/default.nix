{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  bindings = import ./bindings.nix { inherit lib pkgs; };
  prg = config.programs;
in
{
  imports = [
    ./theme.nix
  ];

  config = {
    home.packages = [ pkgs.tmux ];

    xdg.configFile."tmux/tmux.conf".text = ''
      if-shell -b "test \"$(gsettings2 get org.gnome.desktop.interface color-scheme)\" = \"'prefer-light'\"" {
        source-file ~/.config/tmux/light-theme.conf
      }

      if-shell -b "test \"$(gsettings2 get org.gnome.desktop.interface color-scheme)\" = \"'prefer-dark'\"" {
        source-file ~/.config/tmux/dark-theme.conf
      }

      set -g status off
      set-hook -g window-linked 'if "[ #{session_windows} -gt 1 ]" "set status on"'
      set-hook -g window-unlinked 'if "[ #{session_windows} -lt 2 ]" "set status off"'

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
      set -g renumber-windows on
      setw -g window-status-current-format "#[reverse dim] #[nodim bold] #{pane_current_command} #{b:pane_path} #[dim] "
      setw -g window-status-format "#{?#{||:#{==:#I,0},#{==:#{e|-:#I,1},#{active_window_index}}},#{?#{==:#I,0},  ,},#[dim]| #[nodim]}#{pane_current_command} #{b:pane_path}"

      # Prevent jump to prompt once selected text is copied
      unbind -T copy-mode-vi MouseDragEnd1Pane

      ${bindings.tmux}
    '';

    programs.alacritty.settings.keyboard.bindings = mkIf prg.alacritty.enable bindings.alacritty;
  };
}
