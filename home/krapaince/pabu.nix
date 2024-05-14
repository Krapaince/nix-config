{ ... }:
let common_monitors = import (./features/desktop/common/monitors.nix);
in {
  imports = [ ./global ./features/desktop/hyprland ];

  monitors = ([{
    name = "eDP-1";
    primary = true;
  }]) ++ common_monitors.monitors;
}
