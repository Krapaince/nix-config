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
  config = mkIf prg.zathura.enable {
    home.packages = [ pkgs.zathura ];
    xdg.configFile."zathura/zathurarc".text = ''
      set selection-clipboard "clipboard"
    '';

  };
}
