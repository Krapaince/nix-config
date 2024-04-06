{ pkgs, config, ... }:
{
  users.mutableUsers = false;
  users.users.krapaince = {
    isNormalUser = true;
    shell = pkgs.fish
    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages = [ pkgs.home-manager ];
  }

  home-manager.users.krapaince = import ../../../home/krapaince/${config.networking.hostName}.nix;
}
