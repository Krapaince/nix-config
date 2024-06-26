{ lib, config, pkgs, ... }:
let
  hyprctl =
    lib.getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl";
  lockScript = lib.getExe pkgs.lock-script;

  lockTime = 5 * 60;
  dpmsOff = lockTime - 20;
in {
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";

    timeouts = [
      {
        timeout = dpmsOff;
        command = "${hyprctl} dispatch dpms off";
        resumeCommand = "${hyprctl} dispatch dpms on";
      }
      {
        timeout = lockTime;
        command = lockScript;
      }
    ];
  };
}
