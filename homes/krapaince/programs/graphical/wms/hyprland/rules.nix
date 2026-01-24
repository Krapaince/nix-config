{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkIf;

  rofi = getExe pkgs.rofi;
  env = osConfig.modules.usrEnv;
in
{
  config = mkIf env.wms.hyprland.enable {
    wayland.windowManager.hyprland.extraConfig = ''
      layerrule = no_anim on, match:namespace ^(${rofi})$

      # Smart gaps (https://wiki.hyprland.org/Configuring/Workspace-Rules/#smart-gaps)
      workspace=w[tv1], gapsout:0, gapsin:0
      workspace=f[1], gapsout:0, gapsin:0

      # Smart gaps
      windowrule = border_size 0, rounding 0, match:float 0, match:workspace w[tv1]
      windowrule = border_size 0, rounding 0, match:float 0, match:workspace f[1]

      windowrule = pin on, match:class ^dragon-drop$

      windowrule = float on, match:title ^(?:Coping|Moving) - Dolphin

      windowrule = idle_inhibit fullscreen, match:class firefox
      windowrule = float on, match:title ^Opening, match:class firefox
      windowrule = idle_inhibit fullscreen, float on, pin on, move ((monitor_w*0.5)) ((monitor_h*0.01)), match:title ^Picture-in-Picture$

      windowrule = float on, match:class ^Matplotlib$

      windowrule = float on, match:class protonvpn-app

      windowrule = float on, match:title ^satty$

      windowrule = float on, pin on, no_blur on, opacity 1.0 override 1.0 override, match:title ^Floating Window - Show Me The Key$

      windowrule = idle_inhibit fullscreen, match:class vlc
    '';
  };
}
