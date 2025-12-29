{ config, ... }:
let
  mainUsername = config.modules.system.mainUser.name;
  passwordKey = "${mainUsername}-password";
in
{
  users.users.root.hashedPasswordFile = config.sops.secrets.${passwordKey}.path;
}
