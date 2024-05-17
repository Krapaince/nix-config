{ lib, ... }:

let inherit (lib) mkOption types;
in {
  options.git = {
    userName = mkOption {
      type = types.str;
      default = "Krapaince";
    };
    userEmail = mkOption {
      type = types.str;
      default = "Krapaince@pm.me";
    };
  };
}
