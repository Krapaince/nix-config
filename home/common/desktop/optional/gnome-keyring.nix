{ pkgs, ... }:
{
  # TODO Add keyring option
  home.packages = with pkgs; [ seahorse ];
}
