{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
in
{
  toggle-animation = callPackage ./toggle-animation.nix { };
}
