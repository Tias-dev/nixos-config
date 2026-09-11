{
  config.flake.lib = {
    mkNtfyService = {port ? 2586}: {config, ...}: {
      assertions = [
        {
          assertion = config.networking.domain != null;
          message = "config.networking.domain must be set(e.g. example.org) to use this multidomain nginx config";
        }
        {
          assertion = config.services.nginx.enable == true;
          message = "Expected nginx to be enabled but it is not";
        }
      ];
      services.ntfy-sh = {
        enable = true;
        settings = {
          base-url = "https://ntfy.${config.networking.domain}";
          listen-http = ":${toString port}";
          behind-proxy = true;
          auth-file = "/var/lib/ntfy-sh/user.db";
          auth-default-access = "deny-all";
          enable-signup = false;
          # auth-access = [
          #   "admin:*:rw"
          #   "notifier:notify-*:w"
          #   "notify-forwarder:notify-*:r"
          # ];
        };
      };
      services.nginx.virtualHosts = {
        "ntfy.${config.networking.domain}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://localhost:${toString port}";
            proxyWebsockets = true; # Required for ntfy streaming
          };
        };
      };

      # service to create admin, notifier and notify-forwarder users
      systemd.services.ntfy-sh.postStart = let
        ntfy-bin = "${config.services.ntfy-sh.package}/bin/ntfy";
      in
        /*
        bash
        */
        ''
          NTFY_PASSWORD="$(cat ${config.sops.secrets.ntfy-admin-pass.path})" ${ntfy-bin} user add admin || true
          NTFY_PASSWORD="$(cat ${config.sops.secrets.ntfy-notifier-pass.path})" ${ntfy-bin} user add notifier || true
          NTFY_PASSWORD="$(cat ${config.sops.secrets.ntfy-notify-forwarder-pass.path})" ${ntfy-bin} user add notify-forwarder || true
          # sync passwords if users already exists
          NTFY_PASSWORD="$(cat ${config.sops.secrets.ntfy-admin-pass.path})" ${ntfy-bin} user change-pass admin || true
          NTFY_PASSWORD="$(cat ${config.sops.secrets.ntfy-notifier-pass.path})" ${ntfy-bin} user change-pass notifier || true
          NTFY_PASSWORD="$(cat ${config.sops.secrets.ntfy-notify-forwarder-pass.path})" ${ntfy-bin} user change-pass notify-forwarder || true

          ${ntfy-bin} user change-role admin admin

          ${ntfy-bin} access notifier 'notify-*' write-only
          ${ntfy-bin} access notify-forwarder 'notify-*' read-only
        '';

      # secret specs
      sops.secrets = {
        ntfy-admin-pass = {
          sopsFile = ../../secrets/ntfy/secrets.yaml;
          format = "yaml";
          key = "admin-password";
          owner = "ntfy-sh";
        };
        ntfy-notifier-pass = {
          sopsFile = ../../secrets/ntfy/secrets.yaml;
          format = "yaml";
          key = "notifier-password";
          owner = "ntfy-sh";
        };
        ntfy-notify-forwarder-pass = {
          sopsFile = ../../secrets/ntfy/secrets.yaml;
          format = "yaml";
          key = "notify-forwarder-password";
          owner = "ntfy-sh";
        };
      };
    };
  };
}
