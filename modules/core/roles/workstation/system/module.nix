{
  imports = [
    ./fonts.nix
    ./programs
    ./services
  ];

  system.nixos.tags = [ "workstation" ];
}
