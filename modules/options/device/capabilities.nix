{ lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) bool;
in
{
  options.modules.device = {
    hasBluetooth = mkOption {
      type = bool;
      default = false;
    };

    hasSound = mkOption {
      type = bool;
      default = true;
    };
  };
}
