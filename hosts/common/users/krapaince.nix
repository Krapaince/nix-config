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

  # TODO: Unique key per host/user couple
  openssh.authorizedKeys.keys = [ (builtins.readFile ../../../home/krapaince/) ];

  home-manager.users.krapaince = import ../../../home/krapaince/${config.networking.hostName}.nix;
}
