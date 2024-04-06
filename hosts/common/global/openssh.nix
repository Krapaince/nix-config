{ outputs, lib, config, ... }:

let
  inherit (config.networking) hostname;
  hosts = outputs.nixosConfigurations;
  pubKey = host: ../../${host}/ssh_host_rsa_key.pub;
in
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";

      StreamLocalBindUnlink = "yes";

      GatewayPorts = "clientspecified";
    };

    hostKeys = [{
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  programs.ssh = {
    knownHosts = builtins.mapAttrs
      (name: _: {
        pubicKeyfile = pubKey name;
        extraHostNames =
          (lib.optional (name == hostName) "localhost"); # Alias for localhost if it's the same host
      })
      hosts;
  };
}
