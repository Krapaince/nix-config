{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;

  sys = config.modules.system;
in
{
  options.modules.usrEnv.programs.launchers = {
    rofi.enable = mkEnableOption "rofi application launcher" // {
      default = sys.video.enable;
    };
  };
}
