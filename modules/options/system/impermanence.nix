{ lib, ... }:
let
  inherit (lib) mkOption;
in
{
  options.modules.system.impermanence = {
    enable = mkOption {
      type = lib.types.bool;
      description = ''
        Whether or not to enable impermanence which resetsk
      '';
    };

    mountpoint = mkOption {
      type = lib.types.str;
      default = "/persist";
    };
  };
}
