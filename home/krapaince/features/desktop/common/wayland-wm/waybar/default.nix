{ config, lib, pkgs, ... }: {
  systemd.user.services.waybar = { Unit.StartLimitBurst = 30; };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = let
      network-interfaces = config.waybar.network-interfaces;

      primary-screen = (lib.findFirst (m: m.primary) null config.monitors).name;

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
      (let
        swaync-client = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
      in {
        name = "primary-top";
        layer = "top";
        output = "${primary-screen}";
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
          exec = "${swaync-client} -swb";
          on-click = "${swaync-client} -d";
        };

        tray = {
          icon-size = 16;
          spacing = 5;
        };
      })
      (let
        playerctl = lib.getExe' config.services.playerctld.package "playerctl";
      in {
        name = "primary-bottom";
        layer = "top";
        position = "bottom";
        output = "${primary-screen}";
        margin-bottom = 3;
        margin-top = 2;
        modules-left = [ "disk" ];
        modules-center = [ "custom/media" ];
        modules-right = (if (network-interfaces.wired.name != null) then
          [ "network#net-wired" ]
        else
          [ ]) ++ (if (network-interfaces.wireless.name != null) then
            [ "network#net-wireless" ]
          else
            [ ]) ++ [ "temperature#cpu" "cpu" "memory" ];
        disk = {
          interval = 10;
          format = "  {free}";
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
            ${playerctl} -a metadata --format '{"text": "{{playerName}}: {{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
          on-click = "${playerctl} play-pause";
        };
        "network#net-wired" = {
          interface = "${toString network-interfaces.wired.name}";
          interval = 1;
          format-ethernet = "󰈀   {bandwidthDownOctets}  {bandwidthUpOctets}";
          format-disconnected = "";
        };
        "network#net-wireless" = {
          interface = "${toString network-interfaces.wireless.name}";
          interval = 1;
          format-wifi =
            "  {essid}  {bandwidthDownOctets}  {bandwidthUpOctets}";
          format-disconnected = "";
        };
        "temperature#cpu" = {
          hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input";
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
      })
      {
        layer = "top";
        output = "!${primary-screen}";
        margin-top = 2;
        margin-bottom = 7;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/submap" "hyprland/window" ];
        modules-right = [ "clock" ];
      }
    ];
    style = # css
      ''
        ${builtins.readFile ./color.css}

        * {
          font-family: ${config.fontProfiles.regular.family};
          font-size: 12px;
          border: none;
          border-radius: 0;
          background-color: transparent;
          padding: 0;
          margin: 0;
        }

        window#waybar {
          background: transparent;
          margin-left: 1px;
          margin-right: 1px;
          margin-bottom: 20px;
          margin-top: 20px;
        }

        #backlight,
        #battery,
        #bluetooth.connected,
        #clock,
        #cpu,
        #custom-audio-idle-inhibitor,
        #temperature,
        #custom-media,
        #custom-notification,
        #disk,
        #language,
        #memory,
        #network
        #mpd,
        #network,
        #pulseaudio,
        #submap,
        #tray,
        #window,
        #workspaces {
          margin: 0 4px;
          padding: 0 12px;
          background: @bg_primary_darker;
          border-radius: 26px;
          color: @fg_primary;
        }

        #submap {
          color: @red;
        }

        #pulseaudio.muted {
          color: @grey;
        }

        #custom-notification.dnd-none,
        #custom-notification.dnd-notification
        {
          color: @grey;
        }

        #disk {
          color: @orange;
        }

        #battery {
          color: @bg_primary_darker;
        }

        #battery.full {
          background-color: @grshade5;
        }

        #battery.good {
          background-color: @green;
        }

        #battery.ok {
          background-color: @lime;
        }

        #battery.warning {
          background-color: @yellow;
        }

        #battery.bad {
          background-color: @amber;
        }

        #battery.critical {
          background-color: @orange;
        }

        @keyframes blink {
            to {
                background-color: transparent;
            }
        }

        #battery.critical:not(.Unknown) {
            background-color: @orange;
            animation-name: blink;
            animation-duration: 2s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #custom-cpu-temperature.max,
        #cpu.max {
          color: @amshade1;
        }

        #custom-cpu-temperature.high,
        #cpu.high {
          color: @amshade3;
        }

        #custom-cpu-temperature.medium,
        #cpu.medium {
          color: @amshade5;
        }

        #custom-cpu-temperature.light,
        #cpu.light {
          color: @amshade7;
        }

        #custom-cpu-temperature.idle,
        #cpu.idle {
          color: @amshade48
        }

        #memory.problem {
          color: @lbshade4;
        }

        #memory.full {
          color: @yeshade1;
        }

        #memory.half-full {
          color: @yeshade3;
        }

        #memory.half {
          color: @yeshade5;
        }

        #memory.half-empty {
          color: @yeshade6;
        }

        #memory.empty {
          color: @yeshade8;
        }

        #workspaces {
        	background: @bg_primary_darker;
        	border-radius: 26px;
        	margin-bottom: 0;
        	margin-left: 12px;
          padding: 0 0px;
        }

        #workspaces button {
        	background: transparent;
        	color: @fg_primary;
        	transition: none;
          padding: 0 10px;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
        }

        #workspaces button.urgent {
          border-radius: 26px;
          background-color: @blue;
        }

        @define-color active_workspace_color #bf8300;
        @keyframes workspace-active {
          from {
            background-color: @bg_primary_darker;
          }
          to {
            background-color: @active_workspace_color;
          }
        }

        #workspaces button.active {
          color: @bg_primary_darker;
          border-radius: 26px;
          font-weight: bold;
          background-color: @active_workspace_color;
          animation-name: workspace-active;
          animation-duration: 0.2s;
          animation-timing-function: linear;
        }
      '';
  };
}
