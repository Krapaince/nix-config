{
  inputs',
  lib,
  self',
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  inherit (self) inputs;

  env = config.modules.usrEnv;
  mainUser = config.modules.system.mainUser;

  specialArgs = {
    inherit
      inputs
      self
      inputs'
      self'
      ;
  };
in
{
  home-manager = mkIf env.useHomeManager {
    verbose = true;
    useGlobalPkgs = true;
    useUserPackages = true;

    # Don't fail, just replace the dam file
    backupFileExtension = "hm.old";

    extraSpecialArgs = specialArgs;

    users.${mainUser.name} = ./${mainUser.import} + /home.nix;

    sharedModules = [
      {
        imports = [
          self.homeManagerModules.theme
        ];

        nix.package = mkForce config.nix.package;

        programs.home-manager.enable = true;
        sops = { inherit (config.sops) defaultSopsFile; };
      }
    ];
  };
}
