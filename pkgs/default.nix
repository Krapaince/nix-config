{ pkgs ? import <nixpkgs> { }, ... }: {
  # Personal script
  hyprland-ipc = pkgs.callPackage ./hyprland-ipc { };
  lock-script = pkgs.callPackage ./lock-script { };
}
