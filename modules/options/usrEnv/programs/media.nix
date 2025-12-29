{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.modules.usrEnv.programs.media = {
    enableDefaultPackages = mkOption {
      description = "Whether to enable the default list of media-related packages.";
      default = true;
      type = types.bool;
    };
  };
}
