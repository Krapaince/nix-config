{ config, lib, ... }:
{
  config = lib.custom.withMainUser config (
    { username, ... }: {
      users.users.root.hashedPasswordFile = config.sops.secrets."${username}-password".path;
    }
  );
}
