{ config, ... }:
let
  sys = config.modules.system;
  fs = sys.filesystem;
in
{
  config = {
    boot = {
      supportedFilesystems = fs.enabledFilesystems;
      initrd.supportedFilesystems = fs.enabledFilesystems;
    };
  };
}
