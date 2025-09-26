{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../common
    ../common/wayland-wm

    ../../cli/optional/gpg.nix
    ../../cli/optional/yazi.nix
    ../../cli/optional/yt-dlp.nix

    ../../scripts/default.nix

    ../optional/bluetooth.nix
    ../optional/gnome-keyring.nix

    ./bindings.nix
    ./rules.nix

    ./hypridle.nix
  ];

  xdg.portal =
    let
      hyprland = config.wayland.windowManager.hyprland.package;
      xdph = pkgs.xdg-desktop-portal-hyprland.override { inherit hyprland; };
    in
    {
      extraPortals = [ xdph ];
      configPackages = [ hyprland ];
    };

  services.hyprpolkitagent.enable = true;

  home.packages = with pkgs; [
    grim
    satty
    slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      input = {
        kb_layout = "us,fr";
        kb_variant = ",azerty";
        kb_options = "grp:win_space_toggle";
        repeat_rate = 50;
        repeat_delay = 200;

        follow_mouse = 1;

        touchpad = {
          natural_scroll = false;
        };

        sensitivity = 0;
      };

      binds.movefocus_cycles_fullscreen = false;

      device = {
        name = "tpps/2-ibm-trackpoint";
        sensitivity = 1.2;
      };

      general = {
        gaps_in = 7;
        gaps_out = 3;
        border_size = 1;
        "col.active_border" = "rgba(bf8300ee) rgba(ff5a00ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          xray = true;
        };

        shadow.enabled = false;
      };

      animations = {
        enabled = false;

        bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.0" ];

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 95%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_autoreload = false;
      };

      monitor =
        let
          toHyprlandMonitor = (
            m:
            let
              flipped = if m.transform.flipped then 1 else 0;
              rotation = m.transform.rotation / 90;
              transform =
                if m.transform.rotation != 0 || m.transform.flipped then
                  ", transform, ${toString (flipped + rotation)}"
                else
                  "";
            in
            "${m.name},${
              if m.enabled then
                "${toString m.width}x${toString m.height}@${toString m.refreshRate},${toString m.x}x${toString m.y},1${transform}"
              else
                "disable"
            }"
          );
          resolvedMonitors = lib.custom.resolveMonitors config.monitors;
        in
        map toHyprlandMonitor resolvedMonitors;
    };
    extraConfig = ''
      gesture = 4, horizontal, workspace
    '';
    systemd.enable = true;
  };

  systemd.user.services.hyprland-ipc = {
    Unit = {
      Description = "IPC script that handles Hyprland events.";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    Service =
      let
        hyprland_ipc = lib.getExe' pkgs.inputs.hyprland-ipc.hyprland-ipc "hyprland_ipc";
      in
      {
        ExecStart = "${hyprland_ipc} start";
        Restart = "on-failure";
      };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
