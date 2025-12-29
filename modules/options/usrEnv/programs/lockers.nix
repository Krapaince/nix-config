{
  config,
  lib,
  self',
  ...
}:
let
  inherit (lib.types) package;
  inherit (lib.options) mkOption mkEnableOption;

  sys = config.modules.system;
  pkg = self'.packages.lock-script;
in
{
  options.modules.usrEnv.programs.screenlock = {
    swaylock.enable = mkEnableOption "swaylock screenlocker" // {
      default = sys.video.enable;
    };

    package = mkOption {
      type = package;
      default = pkg;
      readOnly = true;
      description = "The screenlocker package";
    };
  };
}
