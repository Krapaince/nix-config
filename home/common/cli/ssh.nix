{ config, inputs, hostSpec, lib, ... }:
let
  hosts = inputs.secrets.hosts;
  internalHostConfs =
    hosts
    |> lib.attrsToList
    |> lib.concatMapStringsSep "\n" ({name, value}: let
      host = name;
      ssh = value.ssh;
      port = if ssh ? port then ssh.port else 22;
      user = if ssh ? user then ssh.user else "krapaince"; in
    ''
    Host ${host} ${value.ip}
      HostName ${value.ip}
      Port ${toString port}
      User ${user}
      ${if ssh ? proxyJump then "ProxyJump ${ssh.proxyJump}\n" else ""}
    '');

  externalHostConfs =
    ''
    Host github.com
      HostName github.com
      User git

    Host gitlab.com
      HostName gitlab.com
      User git
    '';

    secretsPath = builtins.toString inputs.secrets;
in {
  sops.secrets = {
    "ssh_key".sopsFile = "${secretsPath}/hosts/${hostSpec.hostName}.yaml";
  };

  programs.ssh = {
    enable = true;
    matchBlocks."*" = {
      identityFile = [config.sops.secrets."ssh_key".path];
    };
    extraConfig = lib.strings.concatLines [internalHostConfs externalHostConfs];
  };
}
