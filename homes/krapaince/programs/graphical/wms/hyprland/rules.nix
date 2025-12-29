{ lib, osConfig, ... }:
let
  inherit (lib) mkIf;

  env = osConfig.modules.usrEnv;
in
{
  config = mkIf env.wms.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      workspace = [
        # Smart gaps (https://wiki.hyprland.org/Configuring/Workspace-Rules/#smart-gaps)
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];
      windowrulev2 = [
        # Smart gaps
        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "rounding 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"

        "float, title:^(?:Coping|Moving) - Dolphin"

        "idleinhibit fullscreen, class:firefox"

        "idleinhibit fullscreen, title:^Picture-in-Picture$"
        "float, title:^Picture-in-Picture$"
        "pin, title:^Picture-in-Picture$"
        "move 50% 1%, title:^Picture-in-Picture$"
        "pin, class:^dragon-drop$"

        "float, class:^Matplotlib$"

        "float, title:^Floating Window - Show Me The Key$"
        "pin, title:^Floating Window - Show Me The Key$"
        "noblur, title:^Floating Window - Show Me The Key$"
        "opacity 1.0 override 1.0 override, title:^Floating Window - Show Me The Key$"

        "idleinhibit fullscreen, class:vlc"

        "float, title:^satty$"
        "float, class:protonvpn-app"

        "workspace 7 silent, class:WebCord"
        "workspace 7 silent, class:discord"

        "workspace 8 silent, class:blueman-manager"
        "workspace 8 silent, class:Pavucontrol"
        "workspace 8 silent, class:TeamSpeak 3"
      ];
    };
  };
}
