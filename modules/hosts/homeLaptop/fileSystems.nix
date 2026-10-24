{configurations-lib, ...}: {
  config = configurations-lib.personalNixosModule {
    hostname = "laptop-tias";
    module = {pkgs, ...}: {
      boot.supportedFilesystems = ["ntfs"]; # TODO: Move to proper module file

      # TODO: Move client davfs2 mount to distinct module
      sops.secrets.webdav-auth-creds = {
        sopsFile = ../../../secrets/webdav/connection-creds;
        key = "data";
        mode = "0600";
        path = "/etc/davfs2/secrets";
      };

      environment.systemPackages = with pkgs; [
        cifs-utils
        davfs2
      ];
      systemd.mounts = [
        {
          description = "Webdav mount";
          after = ["network-online.target"];
          wants = ["network-online.target"];
          what = "https://webdav.tias-dev.tech";
          where = "/mnt/webdav";
          options = "x-systemd.automount,uid=1000,gid=100";
          type = "davfs";
        }
      ];
      systemd.automounts = [
        {
          description = "Webdav automount";
          where = "/mnt/webdav";
          wantedBy = ["multi-user.target"];
          automountConfig = {
            TimeoutIdleSec = "2m";
          };
        }
      ];

      services.davfs2 = {
        enable = true;
        settings = {
          globalSection = {
            ask_auth = 0;
          };
        };
      };
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
