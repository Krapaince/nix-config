{ lib, ... }:
let
  inherit (lib) mkOption types;

  mkFontOption = kind: {
    family = mkOption {
      type = types.str;
      description = "Family name for ${kind} font profile";
      example = "IosevkaTerm";
    };
    package = mkOption {
      type = types.package;
      description = "Package for ${kind} font profile";
      example = "pkgs.iosevka";
    };
  };
in
{
  options.modules.system.font = {
    regular = mkFontOption "regular";
    monospace = mkFontOption "monospace";
  };
}
