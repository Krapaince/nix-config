{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.meta = {
    hostname = mkOption {
      type = types.str;
      default = config.networking.hostName;
      readOnly = true;
      description = ''
        Shortcut for config.networking.hostName
      '';
    };

  };
}
