{ self, ... }:
let
  mkFlakeModule =
    path: if builtins.isPath path then self + path else builtins.throw "${path} is not a real path!";
in
{
  flake = {
    homeManagerModules = {
      theme = mkFlakeModule /modules/extra/shared/home-manager/theme.nix;
    };
  };
}
