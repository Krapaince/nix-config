{ config, pkgs, ... }: {
  xdg.portal = let
    hyprland = config.wayland.windowManager.hyprland.package;
    xdph = pkgs.xdg-desktop-portal-hyprland.override { inherit hyprland; };
  in {
    enable = true;
    extraPortals = [ xdph ];
    configPackages = [ hyprland ];
  };
}
