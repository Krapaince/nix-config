{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum listOf;

  supportedFilesystems = [
    "vfat"
    "ext4"
    "btrfs"
  ];
in
{
  options.modules.system.filesystem = {
    enabledFilesystems = mkOption {
      type = listOf (enum supportedFilesystems);
      description = ''
        List of filesystems that will be supported by the current host.

        Adding a valid filesystem to this list will automatically add
        said filesystem to the `supportedFilesystems` attribute of the
        `boot` and `boot.initrd` module options.

        It would be a good idea to keep vfat and ext4 so you can mount
        common external storage.
        :::
      '';
    };
  };
}
