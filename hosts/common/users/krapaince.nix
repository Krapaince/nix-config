{ pkgs, config, configLib, inputs, ... }: {
  users.mutableUsers = true;
  users.users.krapaince = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];

    hashedPasswordFile = config.sops.secrets.krapaince-password.path;

    packages = with pkgs; [ home-manager ];
  };

  users.users.root = {
    hashedPasswordFile = config.users.users.krapaince.hashedPasswordFile;
    password = config.users.users.krapaince.password;
    shell = pkgs.fish;
  };

  sops.secrets.krapaince-password =
    let secrets-path = builtins.toString inputs.secrets;
    in {
      sopsFile = "${secrets-path}/hosts/common.yaml";
      neededForUsers = true;
    };

  home-manager = {
    extraSpecialArgs = { inherit configLib; };
    users.krapaince =
      import ../../../home/krapaince/${config.networking.hostName};
  };

  security.pam.services.swaylock = { };
}
