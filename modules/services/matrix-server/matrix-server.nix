{
  config.flake.lib = {
    mkMatrixServer = {
      subdomain,
      matrixPort ? 8008,
    }: {
      config,
      pkgs,
      ...
    }: let
      fqdn = "${subdomain}.${config.networking.domain}";
      baseUrl = "https://${fqdn}";
      clientConfig."m.homeserver".base_url = baseUrl;
      serverConfig."m.server" = "${fqdn}:443";
      mkWellKnown = data: ''
        default_type application/json;
        add_header Access-Control-Allow-Origin *;
        return 200 '${builtins.toJSON data}';
      '';
    in {
      assertions = [
        {
          assertion = config.networking.domain != null;
          message = "config.networking.domain must be set(e.g. example.org) to use this multidomain nginx config";
        }
      ];
      # postgresql for matrix server
      systemd.services.init-matrix-db = {
        description = "Init matrix db and role after postgresql starts";
        after = ["postgresql.service"];
        wants = ["postgresql.service"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "oneshot";
          User = "postgres";
          RemainAfterExit = true;
        };

        script =
          /*
          bash
          */
          ''
            ${config.services.postgresql.package}/bin/psql -f ${./matrix-postgres-init.sql}
          '';
      };

      # nginx extra config
      services.nginx.virtualHosts = {
        "${config.networking.domain}" = {
          locations = {
            "= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
            "= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
          };
        };
        "${fqdn}" = {
          enableACME = true;
          forceSSL = true;
          locations = {
            "/".extraConfig = ''
              return 404;
            '';
            "/_matrix".proxyPass = "http://[::1]:${toString matrixPort}";
            "/_synapse/client".proxyPass = "http://[::1]:${toString matrixPort}";
            "= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
            "= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
          };
        };
        # Element web UI
        "chat.${fqdn}" = {
          enableACME = true;
          forceSSL = true;
          serverAliases = ["chat.${config.networking.domain}"];

          root = pkgs.element-web.override {
            conf = {
              default_server_config = clientConfig; # see `clientConfig` from the snippet above.
              default_theme = "dark";
            };
          };
        };
      };
      # matrix based on synapse config
      services.matrix-synapse = {
        enable = true;
        settings = {
          server_name = config.networking.domain;
          public_baseurl = baseUrl;
          listeners = [
            {
              port = matrixPort;
              bind_addresses = ["::1"];
              type = "http";
              tls = false;
              x_forwarded = true;
              resources = [
                {
                  names = [
                    "client"
                    "federation"
                  ];
                  compress = true;
                }
              ];
            }
          ];
        };
        extraConfigFiles = [config.sops.secrets.matrix-shared-secret-file.path];
      };
      # matrix secrets
      sops.secrets.matrix-shared-secret-file = {
        sopsFile = ../../../secrets/matrix/matrix-shared-secret.yaml;
        format = "yaml";
        key = "";
        owner = "matrix-synapse";
      };
      sops.secrets.matrix-shared-secret = {
        sopsFile = ../../../secrets/matrix/matrix-shared-secret.yaml;
        format = "yaml";
        key = "registration_shared_secret";
        owner = "matrix-synapse";
      };
    };
  };
}
