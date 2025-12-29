{ config, lib, ... }:
let
  inherit (lib) mkIf;

  profiles = config.modules.profiles;
in
{
  config.modules.system.programs = mkIf profiles.gaming.enable {
    gaming.enable = true;
  };
}
