{ lib, osConfig, pkgs, ... }:
let
  inherit (lib) mkIf;

  prg = osConfig.modules.system.programs;
in
{
  config = mkIf prg.discord.enable {
    home.packages = [ pkgs.webcord ];
  };
}
