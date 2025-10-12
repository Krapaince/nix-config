{
  lib,
  pkgs,
  config,
  hostSpec,
  ...
}@args:
let
  homeManagerModules = (import (lib.custom.relativeToRoot "modules/home-manager") args);
in
{
  imports = [
    (lib.custom.relativeToRoot "modules/common")
    ./cli
    ./nvim
  ]
  ++ homeManagerModules;

  inherit hostSpec;

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
  };

  home = {
    username = lib.mkDefault "krapaince";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "25.05";
  };
}
