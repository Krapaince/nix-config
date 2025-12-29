{
  imports = [
    ./environment.nix
    ./fonts.nix
    ./systemd.nix
    ./xdg.nix
  ];

  system.nixos.tags = [ "headless" ];
}
