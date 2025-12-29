{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.modules.profiles = {
    gaming.enable = mkEnableOption ''
      Enables gaming related programs such as Steam.
    '';
    workstation.enable = mkEnableOption ''
      A profile aimed for system used daily (a.k.a. workstation).
    '';
    work.enable = mkEnableOption ''
      A profile to specify if the system is work related.

      If set it removes some programs (e.g.: discord, mumble).
    '';
  };
}
