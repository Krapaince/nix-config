{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkMerge;

  secretsPath = builtins.toString inputs.secrets;
  mainUsername = config.modules.system.mainUser.name;

  mainUser = config.users.users.${mainUsername};
  ageFolder = mainUser.home + "/.config/sops/age";

  sys = config.modules.system;
  wireless = sys.networking.wireless;
  impermanence = sys.impermanence;

  sshKeyPath =
    if impermanence.enable then
      "${impermanence.mountpoint}/system/etc/ssh/ssh_host_ed25519_key"
    else
      throw "Trying to make secrets work without impermanence ohoh";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${secretsPath}/hosts/common.yaml";
    validateSopsFiles = false;

    age.sshKeyPaths = [ sshKeyPath ];
  };

  sops.secrets = mkMerge [
    {
      "${mainUsername}-password" = {
        sopsFile =
          let
            sopsFilename = if mainUsername == "mpointec" then "miyuki.yaml" else "common.yaml";
          in
          "${secretsPath}/hosts/${sopsFilename}";
        neededForUsers = true;
      };

      # For home-manager a separate age key is used to decrypt secrets and must
      # be placed onto the host. This is because the user doesn't have read
      # permission for the ssh service private key. However, we can bootstrap
      # the age key from the secrets decrypted by the host key, which allows
      # home-manager secrets to work without manually copying over the age key.
      # These age keys are unique for the user on each host and are generated
      # on their own (i.e. they are not derived from an ssh key).
      "user_age_keys/${mainUsername}" = {
        inherit (mainUser) group;

        owner = mainUser.name;
        sopsFile = "${secretsPath}/hosts/${config.networking.hostName}.yaml";
        path = ageFolder + "/keys.txt";
      };

      appa-dn = { };
      "wireguard/port" = { };
    }
    (mkIf wireless.connections.base'.enable {
      "wireless/base/ssid" = { };
      "wireless/base/psk" = { };
    })
    (mkIf wireless.connections.secretBase'.enable {
      "wireless/secret-base/ssid" = { };
      "wireless/secret-base/psk" = { };
    })
  ];

  # The containing folders are created as root and if this is the first
  # ~/.config/ entry, the ownership is busted and home-manager can't target
  # because it can't write into .config...
  # FIXME: We might not need this depending on how
  # https://github.com/Mic92/sops-nix/issues/381 is fixed
  system.activationScripts.sopsSetAgeKeyOwnwership = ''
    mkdir -p ${ageFolder} || true
    chown -R ${mainUser.name}:${mainUser.group} ${mainUser.home}/.config
  '';
}
