{ pkgs, config, ... }: {
  users.mutableUsers = true;
  users.users.krapaince = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];

    # TODO: Unique key per host/user couple
    initialPassword = "password";
    openssh.authorizedKeys.keyFiles = [ ../../../home/krapaince/ssh.pub ];

    packages = with pkgs; [ home-manager ];
  };

  home-manager.users.krapaince =
    import ../../../home/krapaince/${config.networking.hostName}.nix;
}
