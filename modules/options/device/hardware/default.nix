{ config, lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr enum;
in
{
  imports = [
    ./monitors.nix
  ];

  options.modules.device = {
    type = mkOption {
      type = enum [
        "laptop"
        "server"
      ];
      default = null;
      description = ''
        The type/purpose of the device that will be used within the rest of the configuration:
        - laptop: portable device
        - server: server
      '';
    };

    cpu = {
      type = mkOption {
        type = nullOr (enum [
          "intel"
          "amd"
          "pi"
        ]);
        default = null;
      };
    };
  };

  config.assertions = [
    {
      assertion = config.modules.device.type != null;
      message = ''
        No device type set. Please define it.
      '';
    }
  ];
}
