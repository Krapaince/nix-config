{ config, ... }:
let
  sys = config.modules.system;
  fs = sys.filesystem;
in
{
  config = {
    boot = {
      supportedFilesystems = fs.enabledFilesystems;
      initrd.supportedFilesystems = fs.enabledFilesystems;
    };

    services = {
      fstrim = {
        enable = true;
        interval = "weekly";
      };
    };

    systemd.services.fstrim = {
      unitConfig.ConditionACPower = true;

      serviceConfig = {
        Nice = 19;
        IOSchedulingClass = "idle";
      };
    };
  };
}
