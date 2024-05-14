{ pkgs, lib, config, ... }:
let
  pipewire-control = lib.getExe pkgs.polybar-pulseaudio-control;
  playerctl = lib.getExe' config.services.playerctld.package "playerctl";

  directions = {
    h = "l";
    l = "r";
    k = "u";
    j = "d";
  };
  mainMod = "ALT";
in {
  wayland.windowManager.hyprland = {
    settings = {
      bind = let
        grim = lib.getExe pkgs.grim;
        rofi = lib.getExe pkgs.rofi-wayland;
        satty = lib.getExe pkgs.satty; # TODO add script files too
        slurp = lib.getExe pkgs.slurp;
        swaync-client = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
        wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";

        defaultApp = type: "${lib.getExe pkgs.handlr-regex} launch ${type}";

        workspaces = map (w:
          let number = if w == "0" then "10" else w;
          in {
            binding = w;
            id = number;
          }) [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" ];
      in [
        "${mainMod}, Return, exec, ${defaultApp "x-scheme-handler/terminal"}"
        "${mainMod}, D, exec, ${rofi} -show drun -theme ~/.config/rofi/config.rasi"

        "SUPER, Up, exec, ~/.config/hypr/scripts/lock.sh -f && systemctl suspend"
        "SUPER, Right, exec, ~/.config/hypr/scripts/lock.sh"

        "CTRL, Space, exec, ${swaync-client} --hide-latest"
        "${mainMod}, t, exec, ${swaync-client} -t"

        ",Print, exec, ${slurp} | ${grim} -g - - | ${wl-copy}"
        "${mainMod}, Print, exec, ~/.config/hypr/scripts/screenshot.sh"

        "ALT_SHIFT, Q, killactive,"
        "ALT_SHIFT, E, exit,"
        "ALT_SHIFT, P, pin,"
        "CTRL_SHIFT, Space, togglefloating,"
        "${mainMod}, f, fullscreen, 0"
        "${mainMod} SHIFT, f, fullscreen, 1"

        "${mainMod}, g, submap, group"
        "${mainMod}, r, submap, resize"
        "${mainMod}, m, submap, media"

        "CTRL_ALT, h, workspace, e-1"
        "CTRL_ALT, l, workspace, e+1"
      ] ++ (lib.mapAttrsToList
        (key: direction: "${mainMod}, ${key}, movefocus, ${direction}")
        directions) ++ (lib.mapAttrsToList
          (key: direction: "${mainMod} SHIFT, ${key}, movewindow, ${direction}")
          directions)
      ++ (map ({ binding, id }: "${mainMod}, ${binding}, workspace, ${id}")
        workspaces) ++ (map ({ binding, id }:
          "${mainMod} SHIFT, ${binding}, movetoworkspacesilent, ${id}")
          workspaces);

      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      bindl = let pactl = lib.getExe' pkgs.pulseaudio "pactl";
      in [
        ", XF86AudioMute, exec, ${pipewire-control} togmute"
        ", XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"

        ", XF86AudioNext, exec, ${playerctl} next"
        ", XF86AudioPrev, exec, ${playerctl} previous"
        ", XF86AudioPause, exec, ${playerctl} play-pause"
      ];

      bindle = let brightnessctl = lib.getExe pkgs.brightnessctl;
      in [
        ", XF86AudioRaiseVolume, exec, ${pipewire-control} up"
        ", XF86AudioLowerVolume, exec, ${pipewire-control} down"

        ", XF86MonBrightnessDown, exec, ${brightnessctl} -d intel_backlight s 10%-"
        ", XF86MonBrightnessUp, exec, ${brightnessctl} -d intel_backlight s 10%+"
      ];
    };

    extraConfig = let
      moveIntoGroups = lib.strings.concatStringsSep "\n" (lib.mapAttrsToList
        (key: direction:
          "bind = ${mainMod}, ${key}, moveintogroup, ${direction}") directions);

      moreCurrentWorkspaceMonitors = lib.strings.concatStringsSep "\n"
        (lib.mapAttrsToList (key: direction:
          "bind = ${mainMod}, ${key}, movecurrentworkspacetomonitor, ${direction}")
          directions);
    in ''
      submap = group
        bind = ${mainMod}, t, lockgroups, toggle

        bind = , h, changegroupactive, b
        bind = , l, changegroupactive, f

        ${moveIntoGroups}

        bind = , escape, submap, reset
      submap = reset

      submap = resize
        binde = , h, resizeactive, -20 0
        binde = , j, resizeactive, 0 20
        binde = , k, resizeactive, 0 -20
        binde = , l, resizeactive, 20 0

        ${moreCurrentWorkspaceMonitors}

        bind = , escape, submap, reset
      submap = reset

      submap = media
        bind = , h, exec, ${playerctl} previous
        bind = , l, exec, ${playerctl} next
        bind = , p, exec, ${playerctl} play-pause

        bind = , escape, submap, reset
      submap = reset
    '';
  };
}
