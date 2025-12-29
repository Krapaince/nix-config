{ pkgs, lib, ... }:
{
  environment = {
    defaultPackages = lib.mkForce [ ];

    systemPackages = with pkgs; [
      comma
      curl
      htop
      neovim
      rsync
      screen
      vifm
    ];
  };
}
