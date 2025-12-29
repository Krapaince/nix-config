{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str;

  sys = config.modules.system;
in
{
  imports = [
    ./boot.nix
    ./filesystem.nix
    ./font.nix
    ./impermanence.nix
    ./networking
    ./programs
    ./services.nix
  ];

  options.modules.system = {
    mainUser = {
      name = mkOption {
        type = str;
        description = "The main user's name of the system";
      };
      import = mkOption {
        type = str;
        description = "The imported home from homes directory";
        default = sys.mainUser.name;
      };
    };

    sound = {
      enable = mkEnableOption "sound related programs and audio-dependent programs";
    };

    video = {
      enable = mkEnableOption "video drivers and programs that require a graphical user interface";
    };

    bluetooth = {
      enable = mkEnableOption "bluetooth modules, drivers and configuration program(s)";
    };
  };
}
