{ lib, config, ... }:
let inherit (lib) mkOption types;
in {
  options.monitors = mkOption {
    type = types.listOf (types.submodule {
      options = {
        name = mkOption { type = types.str; };
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
        x = mkOption { type = types.nullOr types.int; default = null; };
        y = mkOption { type = types.nullOr types.int; default = null; };
        offsetX = mkOption { type = types.int; default = 0; };
        offsetY = mkOption { type = types.int; default = 0; };
        direction = mkOption {
          type = types.enum [
            "north"
            "east"
            "south"
            "west"
            "north east"
            "north west"
            "south east"
            "south west"
          ];
        };
        relativeTo = mkOption { type = types.str; };
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
    assertions = [
      {
        assertion = ((lib.length config.monitors) != 0)
          -> ((lib.length (lib.filter (m: m.primary) config.monitors)) == 1);
        message = "Exactly one monitor must be set to primary.";
      }
      {
        assertion = (lib.lists.all (monitor:
          ((monitor ? "direction") && monitor ? "relativeTo")
          || !(monitor ? "description")) config.monitors);

        message = "direction must be set if relativeTo is set";
      }
      {
        assertion = (lib.lists.all (monitor:
          ((monitor ? "relativeTo") && monitor ? "direction")
          || !(monitor ? "relativeTo")) config.monitors);
        message = "relativeTo must be set if direction is set";
      }
      {
        assertion = (lib.lists.all
          (m: (!(m ? "relativeTo") && (m ? x) && (m ? y)) || true)
          config.monitors);
        message =
          "monitor should be absolute if there both relative fields (relativeTo and direction) aren't set. Either set all relative fields or set x and y fields.";
      }
    ];
  };
}
