{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.protonvpn;
in
{
  options.protonvpn = {
    enable = lib.mkEnableOption { };
  };

  config = lib.mkIf cfg.enable {
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
