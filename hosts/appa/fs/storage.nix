{
  boot.swraid.enable = true;
  fileSystems = {
    "/srv/library" = {
      device = "/dev/disk/by-uuid/2ec18bdf-df62-4c75-bf5f-04fe9b3fb8dd";
      fsType = "ext4";
    };

    "/srv/library2" = {
      device = "/dev/disk/by-uuid/9d1dee3a-8671-473f-8395-b0cfab9383d1";
      fsType = "ext4";
    };

    "/srv/download" = {
      device = "/dev/disk/by-uuid/30d03e2d-1111-4bf9-84b4-1c708f8e713d";
      fsType = "ext4";
    };
  };
}
