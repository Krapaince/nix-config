{
  imports = [
    ./networking.nix
    ./services
  ];

  system.nixos.tags = [ "laptop" ];
}
