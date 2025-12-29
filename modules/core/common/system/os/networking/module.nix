{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    ./ssh.nix
    ./wireless
  ];

  environment.systemPackages = with pkgs; [
    mtr
    tcpdump
    traceroute
  ];

  networking = {
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    usePredictableInterfaceNames = mkDefault true;
  };
}
