{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (import ./packages { inherit pkgs; }) toggle-animation;

  env = osConfig.modules.usrEnv;
in
{
  imports = [
    ./bindings.nix
    ./ipc.nix
    ./rules.nix
  ];

  config = mkIf env.wms.hyprland.enable {
    home.packages = [ toggle-animation ];
    services.hyprpolkitagent.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        input = {
          kb_layout = "us,fr";
          kb_variant = ",azerty";
          kb_options = "grp:win_space_toggle";
          repeat_rate = 50;
          repeat_delay = 200;

          follow_mouse = 1;

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

        dwindle = {
          force_split = 2;
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

        monitor = import ./monitors.nix { inherit lib osConfig; };
      };
      extraConfig = ''
        gesture = 4, horizontal, workspace
      '';
    };
  };
}
