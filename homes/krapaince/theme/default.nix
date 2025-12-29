{
  config,
  lib,
  osConfig,
  pkgs,
  self',
  ...
}:
let
  inherit (lib) mkIf;

  sys = osConfig.modules.system;
  packages = import ./packages { inherit config pkgs self'; };
in
{
  imports = [
    ./gtk.nix
    ./qt.nix
  ];

  config = mkIf sys.video.enable {
    home.packages = [ packages.switch-theme ];
  };
}
