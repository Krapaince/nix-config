{ config, lib, ... }:
let
  inherit (lib) mkEnableOption;

  prg = config.modules.system.programs;
in
{
  options.modules.system.programs.gaming = {
    enable = mkEnableOption ''
      packages, services and wrappers required for the device to be gaming-ready.
    '';

    steam.enable = mkEnableOption "Steam client" // {
      default = prg.gaming.enable;
    };
  };
}
