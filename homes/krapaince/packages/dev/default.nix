{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  sys = osConfig.modules.system;
  prg = sys.programs;
in
{
  imports = [
    ./iex
  ];

  config = mkIf (prg.dev.enable && sys.video.enable) {
    home.packages = with pkgs; [ zeal ];
  };
}
