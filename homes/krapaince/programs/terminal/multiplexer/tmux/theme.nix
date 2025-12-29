{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.custom) mkThemeSwitchHook;

  configHome = config.xdg.configHome;
in
{
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

  theme.switch.hooks = [
    (mkThemeSwitchHook {
      inherit pkgs;
      program = "tmux";
      runtimeInputs = [ pkgs.tmux ];
      text = ''
        tmux source-file "${configHome}/tmux/$1-theme.conf"
      '';
    })
  ];
}
