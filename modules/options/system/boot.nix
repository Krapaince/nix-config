{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.modules.system.boot = {
    loader = mkOption {
      type = types.enum [
        "none"
        "systemd-boot"
      ];
    };
  };
}
