{ inputs, config, ... }:
let
  isEd25519 = key: key.type == "ed25519";
  getKeyPath = key: key.path;
  keys =
    if config.services.openssh.enable then
      builtins.filter isEd25519 config.services.openssh.hostKeys
    else
      [ { path = config.hostSpec.hostKeyPath; } ];

  secretsDirectory = builtins.toString inputs.secrets;
  secretsFile = "${secretsDirectory}/hosts/common.yaml";

  username = config.hostSpec.username;
  homeDirectory = "/home/${username}";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${secretsFile}";
    validateSopsFiles = false;

    age.sshKeyPaths = map getKeyPath keys;

    secrets = {
      # For home-manager a separate age key is used to decrypt secrets and must
      # be placed onto the host. This is because the user doesn't have read
      # permission for the ssh service private key. However, we can bootstrap
      # the age key from the secrets decrypted by the host key, which allows
      # home-manager secrets to work without manually copying over the age key.
      # These age keys are unique for the user on each host and are generated
      # on their own (i.e. they are not derived from an ssh key).

      "user_age_keys/${username}" = {
        owner = config.users.users.${username}.name;
        inherit (config.users.users.${username}) group;
        sopsFile = "${secretsDirectory}/hosts/${config.networking.hostName}.yaml";
        path = "${homeDirectory}/.config/sops/age/keys.txt";
      };

      # extract username/password to /run/secrets-for-users/ so it can be used
      # to create the user
      "${username}-password" =
        let
          filepath =
            if username == "krapaince" then "hosts/common.yaml" else "hosts/${config.hostSpec.hostName}.yaml";
        in
        {
          sopsFile = "${secretsDirectory}/${filepath}";
          neededForUsers = true;
        };
    };
  };
  # The containing folders are created as root and if this is the first
  # ~/.config/ entry, the ownership is busted and home-manager can't target
  # because it can't write into .config...
  # FIXME: We might not need this depending on how
  # https://github.com/Mic92/sops-nix/issues/381 is fixed
  system.activationScripts.sopsSetAgeKeyOwnwership =
    let
      ageFolder = "${homeDirectory}/.config/sops/age";
      user = config.users.users.${username}.name;
      group = config.users.users.${username}.group;
    in
    ''
      mkdir -p ${ageFolder} || true
      chown -R ${user}:${group} ${homeDirectory}/.config
    '';
}
