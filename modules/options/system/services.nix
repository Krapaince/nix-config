{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.modules.system.services = {
    sshd = {
      enable = mkEnableOption "Whether or not to enable the sshd daemon";
    };
  };
}
