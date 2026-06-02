{ config, lib, ... }:
let
  inherit (lib) mkIf;
  sys = config.modules.system;
in
{
  config = mkIf sys.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}
