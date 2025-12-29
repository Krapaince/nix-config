{ config, lib, ... }:
let
  inherit (lib) mkIf;

  profiles = config.modules.profiles;
  work = profiles.work;
in
{
  config.modules.system.programs = mkIf profiles.workstation.enable {
    chromium.enable = true;
    discord.enable = !work.enable;
    firefox.enable = true;
    protonvpn.enable = !work.enable;
    zathura.enable = true;

    dev.enable = true;
    terminals.alacritty.enable = true;
  };
}
