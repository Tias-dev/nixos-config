{
  config.flake.lib.mkWebDavService = {
    port ? 6065,
    subdomain ? "webdav",
  }: {
    config,
    pkgs,
    ...
  }: let
    dataRoot = "/srv/webdav";
    adminLogin = "tias";
  in {
    assertions = [
      {
        assertion = config.services.nginx.enable;
        message = "Expected nginx to be enabled";
      }
      {
        assertion = config.networking.domain != null;
        message = "Expected domain to be set in order to set nginx virtual host";
      }
    ];
    services.webdav = {
      enable = true;
      environmentFile = config.sops.secrets.webdav-users-passwords.path;
      settings = {
        address = "127.0.0.1";
        port = port;
        behindProxy = true;
        directory = "${dataRoot}/public";
        permissions = "R";
        users = [
          {
            username = "${adminLogin}";
            password = "{env}TIAS_PASSWORD";
            directory = "${dataRoot}";
            permissions = "CRUD";
          }
          {
            username = "guest";
            password = "{env}GUEST_PASSWORD";
            directory = "${dataRoot}/public";
          }
        ];
      };
    };
    sops.secrets.webdav-users-passwords = {
      sopsFile = ../../secrets/webdav/passwords.env;
      format = "dotenv";
      key = "";
    };
    services.nginx.virtualHosts."${subdomain}.${config.networking.domain}" = {
      forceSSL = true;
      enableACME = true;
      http2 = false;
      locations."/" = {
        proxyPass = "http://localhost:${toString port}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_redirect off;
          proxy_set_header REMOTE-HOST $remote_addr;
          proxy_http_version 1.1;


          # Ensure COPY and MOVE commands work by rewriting the Destination header to
          # contain only the path, e.g. /test.txt. Note that the captured group already
          # includes the leading slash: adding another one would produce a Destination
          # such as //test.txt, which is parsed as a host name and rejected.
          set $dest $http_destination;
          if ($http_destination ~ "^https?://[^/]+(?<path>/.*)$") {
            set $dest $path;
          }
          proxy_set_header Destination $dest;
        '';
      };
    };

    systemd.tmpfiles.rules = [
      "d ${dataRoot}/public 0777 nobody nogroup -"
      "d ${dataRoot} 0700 ${config.services.webdav.user} nogroup -"
    ];
    systemd.services.ensure-webdav-data-owner = {
      enable = true;
      name = "ensure-webdav-data-owner.service";
      path = with pkgs; [shadow];
      before = ["webdav.service"];
      serviceConfig = {
        RestartSec = 5;
        Restart = "on-failure";
        Type = "oneshot";
        RemainAfterExit = "no";
        StartLimitBurst = 3;
      };
      wantedBy = ["default.target"];
      script = ''
        set -euo pipefail
        chown -R ${config.services.webdav.user}:nogroup ${dataRoot}
      '';
    };
  };
}
