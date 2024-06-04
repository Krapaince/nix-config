{ outputs, lib, config, ... }: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";

      StreamLocalBindUnlink = "yes";

      GatewayPorts = "clientspecified";
    };

    hostKeys = let
      # Sops needs acess to the keys before the persist dirs are even mounted; so
      # just persisting the keys won't work, we must point at /persist/system
      hasOptinPersistence = config.environment.persistence ? "/persist/system";
    in [{
      path = "${
          lib.optionalString hasOptinPersistence "/persist/system"
        }/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  programs.ssh = let hosts = lib.attrNames outputs.nixosConfigurations;
  in {
    knownHosts = lib.genAttrs hosts (hostname: {
      publicKeyFile = ../../${hostname}/ssh_host_ed25519_key.pub;
      extraHostNames =
        (lib.optional (hostname == config.networking.hostName) "localhost");
    });

  };
}
