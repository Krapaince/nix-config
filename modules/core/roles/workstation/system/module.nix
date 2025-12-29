{
  imports = [
    ./fonts.nix
    ./programs
  ];

  system.nixos.tags = [ "workstation" ];
}
