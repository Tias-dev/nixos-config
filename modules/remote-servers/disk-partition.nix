{
  config.flake.modules.nixos.remote-servers = {
    lib,
    config,
    ...
  }: {
    options.swap-size = lib.mkOption {
      type = lib.types.int;
      default = 4 * 1024; # 4 GB
      description = "swap size in MB(by default 4096)";
    };
    config = {
      swapDevices = [
        {
          device = "/swap.img";
          size = config.swap-size;
        }
      ];
      disko.devices = {
        disk.disk1 = {
          device = lib.mkDefault "/dev/vda";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                name = "boot";
                size = "1M";
                type = "EF02";
              };
              esp = {
                name = "ESP";
                size = "500M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              root = {
                name = "root";
                size = "100%";
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
        lvm_vg = {
          pool = {
            type = "lvm_vg";
            lvs = {
              root = {
                size = "100%FREE";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  mountOptions = [
                    "defaults"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
