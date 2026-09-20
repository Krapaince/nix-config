{ config, lib, ... }:
let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;

  impermanence = sys.impermanence;
in
{
  config = mkIf cfg.sshd.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
        PubkeyAuthentication = "yes";

        StreamLocalBindUnlink = "yes";

        GatewayPorts = "clientspecified";
      };
      hostKeys = mkIf impermanence.enable [
        {
          # Sops needs access to the keys before the persist dirs are even mounted; so
          # just persisting the keys won't work, we must point at /persist/system
          path = impermanence.mountpoint + "/system/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
