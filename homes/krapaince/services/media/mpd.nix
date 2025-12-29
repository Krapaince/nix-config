{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  env = osConfig.modules.usrEnv;
in
{
  config = mkIf env.services.media.mpd.enable {
    home.packages = [ pkgs.playerctl ];

    services = {
      mpris-proxy.enable = true;
      playerctld.enable = true;
    };
  };
}
