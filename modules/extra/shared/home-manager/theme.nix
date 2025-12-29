{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.theme.switch = {
    hooks = mkOption {
      type = types.listOf lib.types.str;
      description = ''
        Extra things to execute when switching theme. The theme will be
        pass as the first argument either "dark" or "light".
      '';
      default = [ ];
    };
  };
}
