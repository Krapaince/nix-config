{ pkgs ? import <nixpkgs> { }, ... }: {
  switch-audio = pkgs.callPackage ./switch-audio { };
  colorbalance2 = pkgs.callPackage ./colorbalance2 { };

  # Personal script
  hyprland-ipc = pkgs.callPackage ./hyprland-ipc { };
  lock-script = pkgs.callPackage ./lock-script { };
  suspend-script = pkgs.callPackage ./suspend-script { };
  wall-gen = pkgs.callPackage ./wall-gen { };
}
