{ config, lib, ... }:
let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf;
  dev = config.modules.device;
in
{
  config = mkIf (elem dev.cpu.type [ "amd" ]) {
    hardware.cpu.amd.updateMicrocode = true;
  };
}
