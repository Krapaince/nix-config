{ pkgs, lib, ... }:
{
  environment = {
    defaultPackages = lib.mkForce [ ];

    systemPackages = with pkgs; [
      comma
      curl
      htop
      man-pages
      neovim
      rsync
      screen
      vifm
    ];
  };
}
