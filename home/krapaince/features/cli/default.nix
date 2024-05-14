{ pkgs, ... }: {
  imports = [ ./fish.nix ./git.nix ];

  home.packages = with pkgs; [
    bat
    bc
    bottom
    delta
    eza
    gitui
    jq
    ripgrep
    swaynotificationcenter
  ];
}
