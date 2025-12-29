{ config, lib, ... }:
let
  inherit (lib) mkIf;

  gaming = config.modules.system.programs.gaming;
in
{
  config = mkIf gaming.enable {
    programs.steam = {
      enable = true;
      # https://github.com/ValveSoftware/steam-for-linux/issues/6615#issuecomment-2238229630
      extest.enable = true;
    };
  };
}
