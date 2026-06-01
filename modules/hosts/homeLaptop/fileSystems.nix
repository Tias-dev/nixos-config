{
  flake.modules.nixos."hosts/laptop-raison" = {
    fileSystems = {
      "/mnt/storage" = {
        device = "/dev/disk/by-uuid/72e155fe-9a80-4c63-a184-54d9510e6466";
        fsType = "ext4";
        options = [
          "defaults"
          "noatime"
          "nofail"
        ];
      };

      # arch os
      "/mnt/arch" = {
        device = "/dev/disk/by-uuid/023a2be4-a552-491d-9372-e0ac5f5582da";
        fsType = "ext4";
        options = [
          "defaults"
          "noatime"
          "nofail"
        ];
      };
      # cachy os
      "/mnt/cachy" = {
        device = "/dev/disk/by-uuid/28571601-4bf2-412c-bc5b-494ad6d6f3b9";
        fsType = "ext4";
        options = [
          "defaults"
          "noatime"
          "nofail"
        ];
      };

      # windows
      "/mnt/windows" = {
        device = "/dev/disk/by-uuid/8E90BFE790BFD3C5";
        fsType = "ntfs";
        options = [
          "defaults"
          "noatime"
          "nofail"
        ];
      };

      "/mnt/wingames" = {
        device = "/dev/disk/by-uuid/B05E100B5E0FC954";
        fsType = "ntfs";
        options = [
          "defaults"
          "noatime"
          "nofail"
        ];
      };

      # shared folder
      "/export/raison" = {
        device = "/mnt/raison";
        options = ["bind"];
      };
    };
    # swap
    swapDevices = [
      {
        device = "/dev/disk/by-uuid/11e5fc57-d2b2-4e02-bdbd-1470370b4705";
      }
    ];
  };
}
