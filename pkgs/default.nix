{ pkgs ? import <nixpkgs> { }, ... }: {
  hyprland-ipc = pkgs.callPackage ./hyprland-ipc { };
}
