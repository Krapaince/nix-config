{
  config = {
    modules.system.networking = {
      wireless = {
        connections = {
          base.enable = true;
          pouet.enable = true;
          secretBase.enable = true;
        };
      };
    };
  };
}
