{configurations-lib, ...}: {
  config = configurations-lib.personalNixosModule {
    hostname = "laptop-tias";
    module = {
      boot.supportedFilesystems = ["ntfs"]; # TODO: Move to proper module file
      fileSystems = {
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
          fsType = "ntfs3";
          options = [
            "defaults"
            "noatime"
            "nofail"
          ];
        };

        "/mnt/wingames" = {
          device = "/dev/disk/by-uuid/B05E100B5E0FC954";
          fsType = "ntfs3";
          options = [
            "defaults"
            "noatime"
            "nofail"
          ];
        };
      };
      # swap
      swapDevices = [
        {
          device = "/swap.img";
          size = 16 * 1024;
        }
      ];
    };
  };
}
