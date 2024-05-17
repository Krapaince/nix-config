{ pkgs, ... }: {
  imports = [ ./fish.nix ./git.nix ./gitui.nix ];

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
