{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  prg = osConfig.modules.system.programs;
in
{
  config = mkIf prg.firefox.enable {
    home.packages = [ pkgs.firefox ];
  };
}
