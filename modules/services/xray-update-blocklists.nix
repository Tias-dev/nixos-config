{config, ...}: let
  inherit (config.meta) xray-assets-path;
in {
  config.flake.modules.nixos.xray-update-blocklists = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options = {
      xray-update-blocklists = {
        enable = lib.mkEnableOptions "Auto update blocklists";
        proxy.enable = lib.mkEnableOptions "Use proxy (from config.netwoking.proxy.default) to download blocklists";
      };
    };

    config = {
      # systemd timer to update blocklists
      systemd.timers."xray-update-blocklists" = lib.mkIf config.xray-update-blocklists.enable {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
          Unit = "xray-update-blocklists.service";
        };
      };
      systemd.services."xray-update-blocklists" = lib.mkIf config.xray-update-blocklists.enable {
        script =
          /*
          bash
          */
          ''
            set -eu
            mkdir -p ${xray-assets-path}
            echo "Start donwnloading geoip.dat..."
            ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/runetfreedom/russia-blocked-geoip/release/geoip.dat -o ${xray-assets-path}/geoip.dat
            echo "geoip.dat downloaded. donwnloading geosite.dat..."
            ${pkgs.curl}/bin/curl https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat -o ${xray-assets-path}/geosite.dat
            echo "All resources downloaded!"
          '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          Restart = "on-failure";
          RestartSec = "5m"; # 5 minute delay if no internet connection
          RemainAfterExit = "no";
          StartLimitIntervalSec = "1h";
          StartLimitBurst = 3;
        };
        environment = lib.mkIf config.xray-update-blocklists.proxy.enable {
          all_proxy = config.networking.proxy.default;
          ftp_proxy = config.networking.proxy.default;
          http_proxy = config.networking.proxy.default;
          https_proxy = config.networking.proxy.default;
          rsync_proxy = config.networking.proxy.default;
        };
      };
    };
  };
}
