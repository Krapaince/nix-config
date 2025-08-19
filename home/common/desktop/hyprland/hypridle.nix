{ lib, pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    settings =
      let
        isLocked = "pgrep swaylock";
        lockTime = 5 * 60;
        dpmsOff = lockTime - 20;
      in
      {
        general = {
          lock_cmd = "if ! ${isLocked}; then ${lib.getExe pkgs.lock-script}; fi";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          inhibit_sleep = 3;
        };
        listener = [
          {
            timeout = dpmsOff;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = lockTime;
            on-timeout = "loginctl lock-session";
          }
        ];
      };
  };
}
