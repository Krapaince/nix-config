{ outputs, lib, config, configVars, ... }: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";

      StreamLocalBindUnlink = "yes";

      GatewayPorts = "clientspecified";
    };

    hostKeys = let
      # Sops needs acess to the keys before the persist dirs are even mounted; so
      # just persisting the keys won't work, we must point at /persist/system
      hasOptinPersistence = config.environment.persistence ? "/persist/system";
    in [{
      path = if hasOptinPersistence then
        configVars.hostKeyPath
      else
        "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  programs.ssh = { };
  # let hosts = [];
  # in {
  #   knownHosts = lib.genAttrs hosts (hostname: {
  #     publicKeyFile = ../../../home/krapaince/${hostname}/ssh.pub;
  #     extraHostNames =
  #       (lib.optional (hostname == config.networking.hostName) "localhost");
  #   });

  # };
}
