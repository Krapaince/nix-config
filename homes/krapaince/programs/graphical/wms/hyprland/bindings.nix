{
  pkgs,
  lib,
  config,
  osConfig,
  self',
  ...
}:
let
  inherit (lib)
    concatStringsSep
    flatten
    getExe
    getExe'
    map
    mapAttrsToList
    mkIf
    singleton
    substring
    ;
  inherit (pkgs) writeShellApplication;

  env = osConfig.modules.usrEnv;

  brightnessctl = getExe pkgs.brightnessctl;

  pipewire-control = getExe pkgs.polybar-pulseaudio-control;
  playerctl = getExe' config.services.playerctld.package "playerctl";
  pactl = getExe' pkgs.pulseaudio "pactl";

  lockScript = getExe self'.packages.lock-script;
  suspendScript = getExe self'.packages.suspend-script;
  suspendCmd = "${lockScript} -f && ${suspendScript}";

  rofi = getExe pkgs.rofi;
  swaync-client = getExe' pkgs.swaynotificationcenter "swaync-client";

  screenshotScript = getExe (writeShellApplication {
    name = "screenshot";
    text = "slurp | grim -g - - | wl-copy";
    runtimeInputs = with pkgs; [
      slurp
      grim
      wl-clipboard
    ];
  });

  screenshotEditScript = getExe (writeShellApplication {
    name = "screenshot-edit";
    text = "slurp | grim -g - - | satty --filename - --copy-command wl-copy --early-exit";
    runtimeInputs = with pkgs; [
      slurp
      grim
      satty
    ];
  });

  workspaces =
    map
      (w: {
        binding = w;
        id = if w == "0" then "10" else w;
      })
      [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        "0"
      ];

  directions = {
    h = "l";
    l = "r";
    k = "u";
    j = "d";
  };
  mainMod = "ALT";
in
{
  config = mkIf env.wms.hyprland.enable {
    wayland.windowManager.hyprland = {
      settings = {
        bind = flatten [
          # TODO make it start a tmux session
          "${mainMod}, Return, exec, ${getExe pkgs.alacritty} -e ${getExe pkgs.tmux} new"
          "${mainMod}, D, exec, ${rofi} -show drun -theme ~/.config/rofi/config.rasi"

          "SUPER, Up, exec, ${suspendCmd}"
          "SUPER, Right, exec, ${lockScript}"

          "CTRL, Space, exec, ${swaync-client} --hide-latest"
          "${mainMod}, t, exec, ${swaync-client} -t"

          ",Print, exec, ${screenshotScript}"
          "${mainMod}, Print, exec, ${screenshotEditScript}"

          "ALT_SHIFT, Q, killactive,"
          ''ALT_SHIFT, E, exec, loginctl terminate-user ""''
          "ALT_SHIFT, P, pin,"
          "CTRL_SHIFT, Space, togglefloating,"
          "${mainMod}, f, fullscreen, 0"
          "${mainMod} SHIFT, f, fullscreen, 1"

          "${mainMod}, w, togglegroup,"
          "ALT_SHIFT, w, moveoutofgroup,"

          "CTRL_ALT, h, workspace, e-1"
          "CTRL_ALT, l, workspace, e+1"

          (mapAttrsToList (key: direction: [
            "${mainMod}, ${key}, movefocus, ${direction}"
            "${mainMod} SHIFT, ${key}, movewindow, ${direction}"
          ]) directions)

          (map (
            { binding, id }:
            [
              "${mainMod}, ${binding}, workspace, ${id}"
              "${mainMod} SHIFT, ${binding}, movetoworkspacesilent, ${id}"
            ]
          ) workspaces)
        ];

        bindm = [
          "${mainMod}, mouse:272, movewindow"
          "${mainMod}, mouse:273, resizewindow"
        ];

        bindl = [
          ", XF86AudioMute, exec, ${pipewire-control} togmute"
          ", XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
          ", F4, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"

          ", XF86AudioNext, exec, ${playerctl} next"
          ", XF86AudioPrev, exec, ${playerctl} previous"
          ", XF86AudioPause, exec, ${playerctl} play-pause"

          ", switch:on:Lid Switch, exec, ${suspendCmd}"
        ];

        bindle = [
          ", XF86AudioRaiseVolume, exec, ${pipewire-control} up"
          ", XF86AudioLowerVolume, exec, ${pipewire-control} down"
          ", XF86MonBrightnessDown, exec, ${brightnessctl} -c backlight set 10%-"
          ", XF86MonBrightnessUp, exec, ${brightnessctl} -c backlight set 10%+"
        ];
      };

      extraConfig =
        let
          mkSubmap = name: bindings: ''
            submap = ${name}
            ${concatStringsSep "\n" (flatten (singleton bindings))}
              bind = , escape, submap, reset
            submap = reset
            bind = ${mainMod}, ${substring 0 1 name}, submap, ${name}
          '';

          submaps = {
            "group" = [
              ''
                bind = ${mainMod}, t, lockgroups, toggle

                bind = , h, changegroupactive, b
                bind = , l, changegroupactive, f
              ''
              (mapAttrsToList (
                key: direction: "bind = ${mainMod}, ${key}, moveintogroup, ${direction}"
              ) directions)
            ];
            "resize" = [
              ''
                binde = , h, resizeactive, -20 0
                binde = , j, resizeactive, 0 20
                binde = , k, resizeactive, 0 -20
                binde = , l, resizeactive, 20 0
              ''
              (mapAttrsToList (
                key: direction: "bind = ${mainMod}, ${key}, movecurrentworkspacetomonitor, ${direction}"
              ) directions)
            ];
            "media" = ''
              bind = , h, exec, ${playerctl} previous
              bind = , l, exec, ${playerctl} next
              bind = , p, exec, ${playerctl} play-pause
            '';
          };
        in
        submaps |> (mapAttrsToList mkSubmap) |> concatStringsSep "\n";
    };
  };
}
