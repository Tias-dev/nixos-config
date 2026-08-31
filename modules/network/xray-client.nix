{
  flake.modules.nixos.xray-client = {
    config,
    username,
    pkgs,
    ...
  }: let
    xray-assets-path = "/usr/share/xray/assets/";
    proxy-addr = "socks5://localhost:10800";
  in {
    services.xray = {
      enable = true;
      settingsFile = config.sops.secrets.xray-client.path;
    };
    systemd.services.xray.environment = {XRAY_LOCATION_ASSSET = xray-assets-path;};
    networking = {
      proxy.default = proxy-addr;
      proxy.noProxy = "127.0.0.1,localhost";
    };
    sops = {
      secrets.xray-client = {
        format = "json";
        sopsFile = ../../secrets/xray-client.json;
        key = "";
        restartUnits = ["xray.service"];
      };
    };

    # systemd timer to update blocklists
    systemd.timers."xray-update-blocklists" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
        Unit = "xray-update-blocklists.service";
      };
    };
    systemd.services."xray-update-blocklists" = {
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
      environment = {
        all_proxy = proxy-addr;
        ftp_proxy = proxy-addr;
        http_proxy = proxy-addr;
        https_proxy = proxy-addr;
        rsync_proxy = proxy-addr;
      };
    };
  };
}
