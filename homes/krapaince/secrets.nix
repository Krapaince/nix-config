{
  config,
  inputs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mergeAttrsList optionalAttrs;

  secretsPath = toString inputs.secrets;
  hostname = osConfig.meta.hostname;
  sys = osConfig.modules.system;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = config.xdg.configHome + "/sops/age/keys.txt";
    secrets = mergeAttrsList [
      {
        "ssh_key".sopsFile = "${secretsPath}/hosts/${hostname}.yaml";
      }
      (optionalAttrs sys.bluetooth.enable { "bluetooth/headset_addr" = { }; })
    ];
  };
}
