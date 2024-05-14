{ lib, config, ... }:
let
  hyprctl =
    lib.getExe' config.wayland.windowManager.hyprland.finalPackage "hyprctl";

  lockTime = 5 * 60;
  dpmsOff = lockTime - 20;
in {
  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = dpmsOff;
        command = "${hyprctl} dispatch dpms off";
        resumeCommand = "${hyprctl} dispatch dpms on";
      }
      {
        timeout = lockTime;
        command = "~/.config/hypr/scripts/lock.sh";
      }
    ];
  };
}
