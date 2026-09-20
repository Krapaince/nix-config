{ config, lib, ... }:
{
  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = lib.custom.isAcceptedDeviceType config [
        "laptop"
        "server"
      ];
      config.enable = true;
      functions.enable = true;
    };
  };
}
