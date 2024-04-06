{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./fish.nix
  ];

  home.packages = with pkgs; [
    bat
    bc
    bottom
    delta
    eza
    jq
    ripgrep

    nil
    nixfmt
  ];
}
