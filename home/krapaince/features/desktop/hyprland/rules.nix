{
  wayland.windowManager.hyprland.settings.windowrulev2 = [
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

    # flameshot
    "move 0 0,class:(flameshot)"
    "pin,class:(flameshot)"
    "noborder,class:(flameshot)"
    "stayfocused,class:(flameshot)"
    "float,class:(flameshot)"

    # avoid transparency
    "opaque,class:(flameshot)"
  ];
}
