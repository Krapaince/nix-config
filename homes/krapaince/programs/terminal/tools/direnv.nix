{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkAfter mkIf;
  prg = osConfig.modules.system.programs;

  tomlFormat = pkgs.formats.toml { };
in
{
  config = mkIf prg.cli.enable {
    home.packages = [
      pkgs.direnv
    ];

    xdg.configFile = {
      "direnv/direnv.toml" = {
        source = tomlFormat.generate "direnv-config" {
          global = {
            strict_env = true;
          };
        };
      };

      "direnv/lib/hm-nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    };

    programs = {
      fish.interactiveShellInit = mkAfter ''
        if not functions -q __direnv_export_eval
          ${getExe pkgs.direnv} hook fish | source
        end
      '';
    };
  };
}
