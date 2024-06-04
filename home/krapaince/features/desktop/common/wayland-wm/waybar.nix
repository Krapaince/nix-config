{ lib, ... }: {
  systemd.user.services.waybar = { Unit.StartLimitBurst = 30; };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = let
      common_modules = {
        clock = {
          interval = 60;
          format = "{:%d/%m/%Y - %H:%M}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        "hyprland/window" = { max-length = 70; };
        "hyprland/workspaces" = { format = "{id}"; };
      };
    in map (bar: lib.trivial.mergeAttrs common_modules bar) [
      {
        name = "primary-top";
        layer = "top";
        output = "eDP-1"; # TODO find primary in monitor config
        margin-top = 2;
        margin-bottom = 7;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/submap" "hyprland/window" ];
        modules-right = [
          "battery"
          "bluetooth"
          "pulseaudio"
          "custom/notification"
          "hyprland/language"
          "clock"
          "tray"
        ];

        "hyprland/language" = {
          format = "󰌌 {}";
          format-en = "us";
          format-fr = "fr";
        };

        battery = {
          format = "{icon} {capacity:2}% {time} {power:0.2f}W";
          format-full = "{icon} {capacity:2}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          states = {
            full = 100;
            good = 99;
            ok = 50;
            warning = 35;
            bad = 20;
            critical = 10;
          };
        };

        bluetooth = {
          format = "";
          format-connected = "󰂰 {device_alias}";
          format-connected-battery =
            "󰂰 {device_alias} {device_battery_percentage}%";
        };

        pulseaudio = {
          format = "{icon}   {volume:2}%";
          format-bluetooth = "󰂰 {volume:2}%";
          format-muted = "󰝟 {volume:2}%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋋";
            default = [ "" "" "" ];
          };
          on-click = "change-sink.sh";
        };

        "custom/notification" = {
          format = "{} {icon} ";
          format-icons = {
            none = "󰂚";
            notification = "󰂚";
            dnd-none = "󰂛";
            dnd-notification = "󰂛";
          };
          return-type = "json";
          exec-if = "which swaync-client"; # TODO replace with pkgs path
          exec = "swaync-client -swb"; # TODO replace with pkgs path
          on-click = "swaync-client -d";
        };

        tray = {
          icon-size = 16;
          spacing = 5;
        };
      }
      {
        name = "primary-bottom";
        layer = "top";
        position = "bottom";
        output = "eDP-1"; # TODO find primary in monitor conf
        margin-bottom = 3;
        margin-top = 2;
        modules-left = [ "disk" ];
        modules-center = [ "custom/media" ];
        modules-right = [
          "network#net-wired"
          "network#net-wireless"
          "custom/cpu-temperature"
          "cpu"
          "memory"
        ];
        disk = {
          interval = 10;
          format = "🖴 {free}";
          path = "/";
        };
        "custom/media" = {
          format = "{icon}{}";
          return-type = "json";
          format-icons = {
            "Playing" = "‣ ";
            "Paused" = "⏸ ";
          };
          max-length = 70;
          exec = ''
            playerctl -a metadata --format '{"text": "{{playerName}}: {{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F''; # TODO replace with nix pkgs
          on-click = "playerctl play-pause"; # TODO
        };
        "network#net-wired" = {
          interface =
            "{{@@ wired_network_interface @@}}"; # TODO replace with network interface
          interval = 1;
          format-ethernet = "󰈀   {bandwidthDownOctets}  {bandwidthUpOctets}";
          format-disconnected = "";
        };
        "network#net-wireless" = {
          interface =
            "{{@@ wireless_network_interface @@}}"; # TODO replace with network interface
          interval = 1;
          format-wifi =
            " {essid}  {bandwidthDownOctets}  {bandwidthUpOctets}";
          format-disconnected = "";
        };
        "custom/cpu-temperature" = {
          exec =
            "~/.config/waybar/scripts/temperature-cpu.sh"; # TODO script replace path
          return-type = "json";
          interval = 2;
          format = " {}°C";
        };
        cpu = {
          interval = 2;
          format = "󰍛 {usage:2}%";
          states = {
            max = 100;
            high = 70;
            medium = 50;
            light = 30;
            idle = 10;
          };
        };
        memory = {
          interval = 2;
          format = "   {avail:0.2f}G";
          states = {
            problem = 100;
            full = 98;
            half-full = 70;
            half = 50;
            half-empty = 30;
            empty = 10;
          };
        };
      }
      {
        layer = "top";
        output = "!eDP-1"; # TODO everything except primary
        margin-top = 2;
        margin-bottom = 7;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/submap" "hyprland/window" ];
        modules-right = [ "clock" ];
      }
    ];
  };
}
