{ lib, ... }: {
  options.network-interfaces = {
    ethernet = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Name of the main ethernet interface";
    };

    wireless = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Name of the main wireless interface";
    };
  };
}
