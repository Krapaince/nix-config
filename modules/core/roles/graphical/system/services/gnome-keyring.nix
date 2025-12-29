{ config, ... }:
let
  sys = config.modules.system;
  env = config.modules.usrEnv;
in
{
  services.gnome.gnome-keyring.enable = sys.video.enable;
  security.pam.services.hyprland.enableGnomeKeyring = sys.video.enable && env.wms.hyprland.enable;
}
