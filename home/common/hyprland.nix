{ lib, ... }:
let
  common_monitors = import (lib.custom.relativeToHome "common/desktop/common/monitors.nix");
in
{
  imports = [
    ./default.nix
    ./desktop/hyprland
  ];

  monitors = common_monitors;
}
