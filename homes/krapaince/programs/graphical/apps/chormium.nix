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
  config = mkIf prg.chromium.enable {
    home.packages = [ pkgs.chromium ];
  };
}
