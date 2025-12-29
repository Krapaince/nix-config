{
  config = {
    modules.system.networking = {
      wireless = {
        connections = {
          base.enable = true;
          secretBase.enable = true;
        };
      };
    };
  };
}
