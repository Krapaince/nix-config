{ lib, ... }: {
  imports = [ (lib.custom.relativeToRoot "hosts/common/network-manager") ];
}
