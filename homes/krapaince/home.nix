{ osConfig, ... }:
let
  mainUser = osConfig.modules.system.mainUser;
  username = mainUser.name;
in
{
  imports = [
    ./misc
    ./packages
    ./programs
    ./secrets.nix
    ./services
    ./theme
  ];

  config = {
    home = {
      username = username;
      homeDirectory = "/home/${username}";
      stateVersion = "26.05";
    };
  };
}
