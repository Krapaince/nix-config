{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) flatten mkIf optionals;

  sys = config.modules.system;
  env = config.modules.usrEnv;

  portal = if env.wms.hyprland.enable then "hyprland" else "gtk";
in
{
  config = mkIf sys.video.enable {
    xdg.portal = {
      enable = true;

      extraPortals =
        with pkgs;
        flatten [
          xdg-desktop-portal-gtk
          (optionals env.wms.hyprland.enable [ pkgs.xdg-desktop-portal-hyprland ])
        ];

      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.Screencast" = [ "${portal}" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "${portal}" ];
        };
      };

      # https://github.com/NixOS/nixpkgs/issues/160923
      xdgOpenUsePortal = true;
    };
  };
}
