{ lib, ... }:
let
  inherit (lib) mkOption types;

  network-interface-option = {
    name = mkOption {
      type = types.nullOr types.str;
      description = "Network interface's name";
      default = null;
    };
  };
in {
  options.waybar.network-interfaces = {
    wired = network-interface-option;
    wireless = network-interface-option;
  };
}
