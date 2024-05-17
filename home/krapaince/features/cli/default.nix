{ pkgs, ... }: {
  imports = [ ./fish.nix ./git.nix ];

  home.packages = with pkgs; [
    bat
    bc
    bottom
    eza
    gitui
    jq
    ripgrep
    swaynotificationcenter
  ];
}
