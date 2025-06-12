{ pkgs, config, inputs, lib, ... }:
let
  username = config.hostSpec.username;
  passwordSecretKey = "${username}-password";
in {
  users = {
    mutableUsers = false;
    users = {
      "${username}" = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [ "networkmanager" "wheel" ];

        hashedPasswordFile = config.sops.secrets."${passwordSecretKey}".path;

        packages = with pkgs; [ home-manager ];
      };

      root = {
        hashedPasswordFile = config.sops.secrets."${passwordSecretKey}".path;
        shell = pkgs.fish;
      };
    };
  };

  sops.secrets."${passwordSecretKey}" = let
    secrets-path = builtins.toString inputs.secrets;
    sopsFile = if username == "mpointec" then "miyuki.yaml" else "common.yaml";
  in {
    sopsFile = "${secrets-path}/hosts/${sopsFile}";
    neededForUsers = true;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      hostSpec = config.hostSpec;
    };
    users."${username}" = import
      (lib.custom.relativeToRoot "home/primary/${config.networking.hostName}");
  };

  security.pam.services.swaylock = { };
}
