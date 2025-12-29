{
  lib,
  osConfig,
  self',
  ...
}:
let
  inherit (lib) getExe mkIf;

  env = osConfig.modules.usrEnv;
  lockScript = getExe self'.packages.lock-script;
in
{
  config = mkIf env.wms.hyprland.enable {
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
            lock_cmd = "if ! ${isLocked}; then ${lockScript}; fi";
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
  };
}
