{ pkgs ? import <nixpkgs> { }, ... }: rec {
  switch-audio = pkgs.callPackage ./switch-audio { };
  colorbalance2 = pkgs.callPackage ./colorbalance2 { };
  gsettings2 = pkgs.callPackage ./gsettings2.nix { };

  # Personal script
  lock-script = pkgs.callPackage ./lock-script { };
  suspend-script = pkgs.callPackage ./suspend-script { };
  wall-gen = pkgs.callPackage ./wall-gen { inherit colorbalance2; };

  # Resources
  wallpapers = pkgs.callPackage ./wallpaper.nix { };
}
