{
  # There placed my custom mount points
  # blobs
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/72e155fe-9a80-4c63-a184-54d9510e6466";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
      "nofail"
    ];
  };

  # arch os
  fileSystems."/mnt/arch" = {
    device = "/dev/disk/by-uuid/023a2be4-a552-491d-9372-e0ac5f5582da";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
      "nofail"
    ];
  };

  # cachy os
  fileSystems."/mnt/cachy" = {
    device = "/dev/disk/by-uuid/28571601-4bf2-412c-bc5b-494ad6d6f3b9";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
      "nofail"
    ];
  };

  # windows
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/8E90BFE790BFD3C5";
    fsType = "ntfs";
    options = [
      "defaults"
      "noatime"
      "nofail"
    ];
  };
  fileSystems."/mnt/wingames" = {
    device = "/dev/disk/by-uuid/B05E100B5E0FC954";
    fsType = "ntfs";
    options = [
      "defaults"
      "noatime"
      "nofail"
    ];
  };

  # swap
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/11e5fc57-d2b2-4e02-bdbd-1470370b4705";
    }
  ];

  # shared folder
  fileSystems."/export/raison" = {
    device = "/mnt/raison";
    options = ["bind"];
  };
}
