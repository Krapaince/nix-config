{ config, keys, ... }:
let
  mainUsername = config.modules.system.mainUser.name;
  passwordKey = "${mainUsername}-password";
in
{
  users.users.${mainUsername} = {
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
