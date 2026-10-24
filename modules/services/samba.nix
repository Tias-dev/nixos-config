# Creates samba service with public read only any one seen section and secured owner section with write access to public section
{
  config.flake.lib.mkSambaService = {}: {
    config,
    pkgs,
    ...
  }: {
    assertions = [
      {
        assertion = config.services.tailscale.enable;
        message = "Connection to samba realized over tailscale tunnel so it is need to be enabled";
      }
    ];
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [445];
    services.samba = {
      enable = true;
      openFirewall = false; # use tailscale tunnel
      nmbd.enable = false;
      settings = {
        global = {
          workgroup = "WORKGROUP";
          "server role" = "standalone server";
          "log file" = "/var/log/samba/log.%m";
          "map to guest" = "Bad User";

          "bind interfaces only" = "no";
          "hosts allow" = ["127.0.0.1" "100.64.0.0/10" "::1"];

          # "hosts deny" = "0.0.0.0/0";
        };
        public = {
          browseable = "yes";
          comment = "Public read only folder";
          "guest ok" = "yes";
          "read only" = "yes";
          "write list" = "temp";
          path = "/srv/samba/public";
          "create mask" = 0664;
          "directory mask" = 0775;
        };
        homes = {
          "read only" = "no";
        };
      };
    };

    # create pulbic folder manually
    systemd.tmpfiles.rules = [
      "d /srv/samba/public 0777 nobody nogroup -"
    ];

    systemd.services.ensure-samba-users = {
      enable = true;
      name = "ensure-samba-users.service";
      path = with pkgs; [jq samba shadow];
      after = ["samba.target"];
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
        getPass() {
          echo "$1" | jq -r '.password'
        }
        cat ${config.sops.secrets.samba-users.path} | jq -cr '.users.[]' | while read userData; do
          username=$(echo $userData | jq -r .user)
          echo "Ensuring system user $username is exists..."
          useradd -ms /run/current-system/sw/sbin/nologin $username || true
          echo "Ensuring samba user $username is registered..."
          echo -e "$(getPass "$userData")\n$(getPass "$userData")" | smbpasswd -sa "$username"
          done
      '';
    };

    sops.secrets.samba-users = {
      sopsFile = ../../secrets/samba/users.json;
      key = "";
      format = "json";
    };
  };
}
