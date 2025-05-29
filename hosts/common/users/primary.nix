{ pkgs, config, inputs, ... }:
let username = config.hostSpec.username;
in {
  users.mutableUsers = false;
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];

    hashedPasswordFile = config.sops.secrets."${username}-password".path;

    packages = with pkgs; [ home-manager ];
  };

  users.users.root = {
    hashedPasswordFile = config.users.users.${username}.hashedPasswordFile;
    password = config.users.users.${username}.password;
    shell = pkgs.fish;
  };

  sops.secrets.krapaince-password =
    let secrets-path = builtins.toString inputs.secrets;
    in {
      sopsFile = "${secrets-path}/hosts/common.yaml";
      neededForUsers = true;
    };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      hostSpec = config.hostSpec;
    };
    users."${username}" =
      import ../../../home/${username}/${config.networking.hostName};
  };

  security.pam.services.swaylock = { };
}
