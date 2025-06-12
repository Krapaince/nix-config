{ pkgs, ... }: {
  imports = [
    ./gammastep.nix
    ./swaync.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar
    ./wpaperd
  ];

  xdg.mimeApps.enable = true;
  home.packages = with pkgs; [
    wf-recorder
    wl-clipboard
    wl-mirror
    wl-screenrec
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    NIXOS_OZONE_WL = 1; # For chromium and electron based apps
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
}
