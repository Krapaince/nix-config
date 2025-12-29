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
      hostname = host.ip;
      user = if ssh ? user then ssh.user else "krapaince";
      port = if ssh ? port then ssh.port else 22;
    }
    // (optionalAttrs (ssh ? proxyJump) { proxyJump = ssh.proxyJump; });

  internalHostConfs = mapAttrs mkMatchBlocks hosts;
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = internalHostConfs // {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        identityFile = mkDefault config.sops.secrets."ssh_key".path;
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
      };
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
      };
    };
  };
}
