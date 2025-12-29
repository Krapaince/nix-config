{ config, lib, ... }:
let
  inherit (lib) mkIf;

  lockers = config.modules.usrEnv.programs.screenlock;
in
{
  config = mkIf lockers.swaylock.enable {
    security.pam.services.swaylock = { };
  };
}
