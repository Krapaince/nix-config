{ lib, ... }: {
  options.hostSpec = let persistFolder = "/persist";
  in {
    identity = {
      email = lib.mkOption { type = lib.types.str; };
      gpg_key = lib.mkOption { type = lib.types.str; };
      userFullName = lib.mkOption { type = lib.types.str; };
    };
    username = lib.mkOption {
      type = lib.types.str;
      description = "The username of the host";
    };
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the host";
    };

    persistFolder = lib.mkOption {
      type = lib.types.str;
      description = "The folder to persist data if impermanence is enabled";
      default = persistFolder;
    };
    hostKeyPath = lib.mkOption {
      type = lib.types.str;
      description = "Path to the host's private key";
      default = "${persistFolder}/system/etc/ssh/ssh_host_ed25519_key";
    };

    isWork = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a host dedicated to work";
    };
  };
}
