{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  prg = config.modules.system.programs;
in
{
  config = mkIf prg.protonvpn.enable {
    networking = {
      networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
      firewall.checkReversePath = false;
    };

    environment.systemPackages = with pkgs; [
      protonvpn-gui
      wireguard-tools
    ];
  };
}
