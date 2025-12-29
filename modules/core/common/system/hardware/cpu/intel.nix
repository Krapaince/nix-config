{
  config,
  lib,
  ...
}:
let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf;
  dev = config.modules.device;
in
{
  config = mkIf (elem dev.cpu.type [ "intel" ]) {
    hardware.cpu.intel.updateMicrocode = true;
    boot = {
      kernelModules = [ "kvm-intel" ];
    };
  };
}
