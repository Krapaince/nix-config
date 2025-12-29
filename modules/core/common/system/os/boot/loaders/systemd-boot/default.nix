{ config, lib, ... }:
let
  inherit (lib) mkDefault mkIf;

  cfg = config.modules.system;
in
{
  config = mkIf (cfg.boot.loader == "systemd-boot") {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 20;
      consoleMode = mkDefault "max";
    };
  };
}
