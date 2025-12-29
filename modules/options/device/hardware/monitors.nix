{ lib, config, ... }:
let
  inherit (lib)
    all
    filter
    length
    mkOption
    types
    ;
  inherit (types)
    bool
    either
    enum
    float
    int
    listOf
    nullOr
    str
    submodule
    ;

  monitors = config.modules.device.monitors;
in
{
  options.modules.device.monitors = mkOption {
    default = [ ];
    description = ''
      A list of monitors connected to the system.

      The declared are then used to configure the window manager and wallpapers.
    '';
    type = listOf (submodule {
      options = {
        name = mkOption { type = str; };
        primary = mkOption {
          type = bool;
          default = false;
        };
        width = mkOption {
          type = int;
          example = 1920;
          default = 1920;
        };
        height = mkOption {
          type = int;
          example = 1080;
          default = 1080;
        };
        refreshRate = mkOption {
          type = either int float;
          default = 60;
        };
        x = mkOption {
          type = nullOr int;
          default = null;
        };
        y = mkOption {
          type = nullOr int;
          default = null;
        };
        offsetX = mkOption {
          type = int;
          default = 0;
        };
        offsetY = mkOption {
          type = int;
          default = 0;
        };
        direction = mkOption {
          type = enum [
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
        relativeTo = mkOption { type = str; };
        transform = {
          rotation = mkOption {
            type = enum [
              0
              90
              180
              270
            ];
            default = 0;
          };
          flipped = mkOption {
            type = bool;
            default = false;
          };
        };
        enabled = mkOption {
          type = bool;
          default = true;
        };
        workspace = mkOption {
          type = nullOr str;
          default = null;
        };
      };
    });
  };

  config = {
    assertions = [
      {
        assertion = ((length monitors) != 0) -> ((length (filter (m: m.primary) monitors)) == 1);
        message = "Exactly one monitor must be set to primary.";
      }
      {
        assertion = (
          all (
            monitor: ((monitor ? "direction") && monitor ? "relativeTo") || !(monitor ? "description")
          ) monitors
        );

        message = "direction must be set if relativeTo is set";
      }
      {
        assertion = (
          all (
            monitor: ((monitor ? "relativeTo") && monitor ? "direction") || !(monitor ? "relativeTo")
          ) monitors
        );
        message = "relativeTo must be set if direction is set";
      }
      {
        assertion = (all (m: (!(m ? "relativeTo") && (m ? x) && (m ? y)) || true) monitors);
        message = "monitor should be absolute if there both relative fields (relativeTo and direction) aren't set. Either set all relative fields or set x and y fields.";
      }
    ];
  };
}
