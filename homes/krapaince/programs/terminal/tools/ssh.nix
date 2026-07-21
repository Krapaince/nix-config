{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) mapAttrs mkDefault optionalAttrs;

  hosts = inputs.secrets.hosts;

  mkMatchBlocks =
    name: host:
    let
      inherit (host) ssh;
    in
    {
      Hostname = host.ip;
      User = if ssh ? user then ssh.user else "krapaince";
      Port = if ssh ? port then ssh.port else 22;
    }
    // (optionalAttrs (ssh ? proxyJump) { proxyJump = ssh.proxyJump; });

  internalHostConfs = mapAttrs mkMatchBlocks hosts;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = internalHostConfs // {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        IdentityFile = mkDefault config.sops.secrets."ssh_key".path;
      };
      "github.com" = {
        Hostname = "github.com";
        User = "git";
      };
      "gitlab.com" = {
        Hostname = "gitlab.com";
        User = "git";
      };
    };
  };
}
