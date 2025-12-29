{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  env = osConfig.modules.usrEnv;
  prg = env.programs;
  gui_prg = osConfig.modules.system.programs.gui;
in
{
  config = mkIf (gui_prg.enable && prg.media.enableDefaultPackages) {
    home.packages = with pkgs; [
      imv
      pavucontrol
      vlc
    ];
  };
}
