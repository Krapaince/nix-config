{
  config,
  pkgs,
  self',
  ...
}:
let
  inherit (pkgs) callPackage;

  themeSwitchHooks = config.theme.switch.hooks;
in
{
  switch-theme = callPackage ./switch-theme.nix {
    inherit themeSwitchHooks;
    inherit (self'.packages) gsettings2;
  };
}
