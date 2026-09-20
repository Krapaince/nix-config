{
  config,
  lib,
  keys,
  ...
}:
{
  config = lib.custom.withMainUser config (
    { username, ... }:
    let
      passwordKey = "${username}-password";
    in
    {
      users.users.${username} = {
        isNormalUser = true;

        hashedPasswordFile = config.sops.secrets.${passwordKey}.path;

        openssh.authorizedKeys.keys = [
          keys.users.miyuki.mpointec
          keys.users.pabu.krapaince
        ];

        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    }
  );
}
