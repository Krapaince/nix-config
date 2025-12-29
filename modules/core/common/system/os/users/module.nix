{ pkgs, ... }:
{
  imports = [
    ./krapaince.nix
    ./root.nix
  ];

  config = {
    users = {
      defaultUserShell = pkgs.fish;

      allowNoPasswordLogin = false;
    };

  };
}
