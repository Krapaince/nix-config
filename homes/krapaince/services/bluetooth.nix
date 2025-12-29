{
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;

  sys = osConfig.modules.system;
in
{
  config = mkIf sys.bluetooth.enable {
    services.blueman-applet.enable = true;

    xdg.configFile = mkIf sys.sound.enable {
      "wireplumber/wireplumber.conf.d/10.bluetooth-policy.conf".text = ''
        wireplumber.settings = {
            bluetooth.autoswitch-to-headset-profile = false
        }
      '';
    };
  };
}
