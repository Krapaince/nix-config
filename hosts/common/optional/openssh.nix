{ config, ... }: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";

      StreamLocalBindUnlink = "yes";

      GatewayPorts = "clientspecified";
    };

    hostKeys = let
      # Sops needs access to the keys before the persist dirs are even mounted; so
      # just persisting the keys won't work, we must point at /persist/system
      hasOptinPersistence = config.environment.persistence ? "/persist/system";
    in [{
      path = if hasOptinPersistence then
        config.hostSpec.hostKeyPath
      else
        "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };
}
