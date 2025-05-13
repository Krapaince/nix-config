{ inputs }:
let
  additions = final: prev: import ../pkgs { pkgs = final; };
  modifications = final: prev: {
    flameshot = prev.flameshot.override { enableWlrSupport = true; };
  };

in {
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs =
      builtins.mapAttrs (
        _: flake: let
          legacyPackages = (flake.legacyPackages or {}).${final.system} or {};
          packages = (flake.packages or {}).${final.system} or {};
        in
          if legacyPackages != {}
          then legacyPackages
          else packages
      )
      inputs;
  };

  default = final: prev: (additions final prev) // (modifications final prev);
}
