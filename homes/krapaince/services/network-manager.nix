{ lib, osConfig, ... }:
let
  inherit (lib) elem mkIf;

  dev = osConfig.modules.device;
  acceptedTypes = [ "laptop" ];
in
{
  config = mkIf (elem dev.type acceptedTypes) {
    services.network-manager-applet.enable = true;
  };
}
