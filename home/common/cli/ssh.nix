{
  config,
  inputs,
  hostSpec,
  lib,
  ...
}:
let
  hosts = inputs.secrets.hosts;

  internalHostConfs = lib.mapAttrs (
    name: host:
    let
      ssh = host.ssh;
    in
    {
      hostname = host.ip;
      user = if ssh ? user then ssh.user else "krapaince";
      port = if ssh ? port then ssh.port else 22;
    }
    // (lib.optionalAttrs (ssh ? proxyJump) { proxyJump = ssh.proxyJump; })
  ) hosts;

  secretsPath = builtins.toString inputs.secrets;
in
{
  sops.secrets = {
    "ssh_key".sopsFile = "${secretsPath}/hosts/${hostSpec.hostName}.yaml";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = internalHostConfs // {
      "*" = {
        forwardAgent = lib.mkDefault false;
        addKeysToAgent = lib.mkDefault "no";
        identityFile = lib.mkDefault config.sops.secrets."ssh_key".path;
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
