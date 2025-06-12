{ lib, config, ... }:
let inherit (lib) mkOption types;
in {
  options.monitors = mkOption {
    type = types.listOf (types.submodule {
      options = {
        name = mkOption {
          type = types.str;
          example = "DP-1";
        };
        primary = mkOption {
          type = types.bool;
          default = false;
        };
        width = mkOption {
          type = types.int;
          example = 1920;
          default = 1920;
        };
        height = mkOption {
          type = types.int;
          example = 1080;
          default = 1080;
        };
        refreshRate = mkOption {
          type = types.int;
          default = 60;
        };
        x = mkOption {
          type = types.int;
          default = 0;
        };
        y = mkOption {
          type = types.int;
          default = 0;
        };
        transform = {
          rotation = mkOption {
            type = types.enum [ 0 90 180 270 ];
            default = 0;
          };
          flipped = mkOption {
            type = types.bool;
            default = false;
          };
        };
        enabled = mkOption {
          type = types.bool;
          default = true;
        };
        workspace = mkOption {
          type = types.nullOr types.str;
          default = null;
        };
      };
    });
    default = [ ];
  };
  config = {
    assertions = [{
      assertion = ((lib.length config.monitors) != 0)
        -> ((lib.length (lib.filter (m: m.primary) config.monitors)) == 1);
      message = "Exactly one monitor must be set to primary.";
    }];
  };
}
