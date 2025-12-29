{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;

  system = config.modules.system;
in
{
  config = mkIf system.video.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
