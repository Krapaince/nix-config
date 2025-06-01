{
  boot = {
    loader = {
      systemd-boot = {
        configurationLimit = 20;
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
