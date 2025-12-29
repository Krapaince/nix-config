{ config, lib, ... }:
let
  inherit (lib) mkForce mkIf;
  dev = config.modules.device;
  cfg = config.modules.system.sound;
in
{
  config = mkIf (cfg.enable && dev.hasSound) {
    security.rtkit.enable = mkForce config.services.pipewire.enable;

    services.pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      wireplumber = {
        enable = true;
      };
    };
  };
}
