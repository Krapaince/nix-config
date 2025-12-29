{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;

  sys = config.modules.system;
in
{
  config = mkIf sys.video.enable {
    environment = {
      variables = {
        NIXOS_OZONE_WL = "1"; # For chromium and electron based apps
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        XDG_SESSION_TYPE = "wayland";
        SDL_VIDEODRIVER = "wayland";
      };
    };
  };
}
