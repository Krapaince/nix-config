{ pkgs ? import <nixpkgs> { }, ... }: {
  switch-audio = pkgs.callPackage ./switch-audio { };

  # Personal script
  hyprland-ipc = pkgs.callPackage ./hyprland-ipc { };
  lock-script = pkgs.callPackage ./lock-script { };
}
