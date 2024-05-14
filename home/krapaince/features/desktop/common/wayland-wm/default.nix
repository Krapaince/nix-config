{ pkgs, ... }: {
  imports =
    [ ./gammastep.nix ./swaync.nix ./swayidle.nix ./swaylock.nix ./waybar.nix ];

  xdg.mimeApps.enable = true;
  home.packages = with pkgs; [ wf-recorder wl-clipboard ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };
}
