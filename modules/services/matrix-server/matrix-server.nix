# You must configure you dns to pass *.{domain} to this server and {domain} itself
# After that matrix backend will use ${submodomain}.{domain} name
# Chat will use chat.${subdomain}.{domain} and chat.{domain}
# Coturn server will use turn.{domain}
# You matrix server may be pointed to by just {domain} name
{
  config.flake.lib = {
    mkMatrixServer = {
      subdomain,
      matrixPort ? 8008,
      networkInterface ? "enp1s0",
      max_upload_file_size ? "1G",
      upload_timeout ? "600s",
    }: {
      config,
      pkgs,
      ...
    }: let
      fqdn = "${subdomain}.${config.networking.domain}";
      baseUrl = "https://${fqdn}";
      clientConfig = {
        "m.homeserver".base_url = baseUrl;
        "org.matrix.msc3575.proxy".url = baseUrl; # for livekit calls
        "org.matrix.msc4143.rtc_foci" = [
          {
            type = "livekit";
            livekit_service_url = "${baseUrl}/livekit/jwt";
          }
        ];
      };
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
          extraConfig = ''
            client_max_body_size ${max_upload_file_size};

            proxy_request_buffering off;

            proxy_connect_timeout ${upload_timeout};
            proxy_send_timeout    ${upload_timeout};
            proxy_read_timeout    ${upload_timeout};
          '';
        };
        "${fqdn}" = {
          enableACME = true;
          forceSSL = true;
          extraConfig = ''
            client_max_body_size ${max_upload_file_size};

            proxy_request_buffering off;

            proxy_connect_timeout ${upload_timeout};
            proxy_send_timeout    ${upload_timeout};
            proxy_read_timeout    ${upload_timeout};
          '';
          locations = {
            "/".extraConfig = ''
              return 404;
            '';
            "/_matrix".proxyPass = "http://[::1]:${toString matrixPort}";
            "/_synapse/client".proxyPass = "http://[::1]:${toString matrixPort}";
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
          extraConfig = ''
            client_max_body_size ${max_upload_file_size};

            proxy_request_buffering off;

            proxy_connect_timeout ${upload_timeout};
            proxy_send_timeout    ${upload_timeout};
            proxy_read_timeout    ${upload_timeout};
          '';
        };
      };
      # matrix based on synapse config
      services.matrix-synapse = {
        enable = true;
        withJemalloc = true;
        settings = {
          server_name = config.networking.domain;
          public_baseurl = baseUrl;
          max_upload_size = max_upload_file_size;
          experimental_features = {
            "org.matrix.msc3401" = true; # Включает нативную поддержку звонков Matrix RTC
            "org.matrix.msc3861" = true; # Требуется для поддержки авторизации в Element X (OIDC)
          };
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
                    "media"
                  ];
                  compress = false;
                }
                {
                  names = [
                    "federation"
                  ];
                  compress = true;
                }
              ];
            }
          ];
        };
        extraConfigFiles = [config.sops.secrets.matrix-extra-config.path];
      };
      # matrix secrets
      sops.secrets.matrix-extra-config = {
        sopsFile = ../../../secrets/matrix/matrix-extra-config.yaml;
        format = "yaml";
        key = "";
        owner = "matrix-synapse";
      };
      sops.secrets.matrix-shared-secret = {
        sopsFile = ../../../secrets/matrix/matrix-extra-config.yaml;
        format = "yaml";
        key = "registration_shared_secret";
        owner = "matrix-synapse";
      };

      imports = [
        # enable live kit for element x calls
        ({config, ...}: let
          keyFile = "/run/livekit.key";
        in {
          services.livekit = {
            enable = true;
            openFirewall = true;
            inherit keyFile;
          };

          services.lk-jwt-service = {
            enable = true;
            livekitUrl = "wss://${fqdn}/livekit/sfu";
            inherit keyFile;
          };
          # generate the key when needed
          systemd.services.livekit-key = {
            before = ["lk-jwt-service.service" "livekit.service"];
            wantedBy = ["multi-user.target"];
            path = with pkgs; [livekit coreutils gawk];

            script = ''
              echo "Key missing, generating key"
              echo "lk-jwt-service: $(livekit-server generate-keys | tail -1 | awk '{print $3}')" > "${keyFile}"
            '';
            serviceConfig.Type = "oneshot";
            unitConfig.ConditionPathExists = "!${keyFile}";
          };
          # restrict access to livekit room creation to a homeserver
          systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = "${fqdn}";
          services.nginx.virtualHosts.${fqdn}.locations = {
            "^~ /livekit/jwt/" = {
              priority = 400;

              proxyPass = "http://[::1]:${toString config.services.lk-jwt-service.port}/";
            };

            "^~ /livekit/sfu/" = {
              extraConfig = ''
                proxy_send_timeout 120;
                proxy_read_timeout 120;
                proxy_buffering off;

                proxy_set_header Accept-Encoding gzip;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
              '';
              priority = 400;
              proxyPass = "http://[::1]:${toString config.services.livekit.settings.port}/";
              proxyWebsockets = true;
            };
          };
        })
        # enable coturn for videocalls
        ({
          config,
          lib,
          ...
        }: {
          sops.secrets.coturn-secret = {
            sopsFile = ../../../secrets/matrix/matrix-extra-config.yaml;
            key = "turn_shared_secret";
            format = "yaml";
            owner = "turnserver";
          };
          services.coturn = rec {
            enable = true;
            no-cli = true;
            no-tcp-relay = true;
            min-port = 49000;
            max-port = 50000;
            use-auth-secret = true;
            static-auth-secret-file = config.sops.secrets.coturn-secret.path;
            realm = "turn.${config.networking.domain}";
            cert = "${config.security.acme.certs.${realm}.directory}/full.pem";
            pkey = "${config.security.acme.certs.${realm}.directory}/key.pem";
            extraConfig = ''
              # for debugging
              syslog
              verbose
              log-file=/var/log/turnserver/coturn.log
              # ban private IP ranges
              no-multicast-peers
              denied-peer-ip=0.0.0.0-0.255.255.255
              denied-peer-ip=10.0.0.0-10.255.255.255
              denied-peer-ip=100.64.0.0-100.127.255.255
              denied-peer-ip=127.0.0.0-127.255.255.255
              denied-peer-ip=169.254.0.0-169.254.255.255
              denied-peer-ip=172.16.0.0-172.31.255.255
              denied-peer-ip=192.0.0.0-192.0.0.255
              denied-peer-ip=192.0.2.0-192.0.2.255
              denied-peer-ip=192.88.99.0-192.88.99.255
              denied-peer-ip=192.168.0.0-192.168.255.255
              denied-peer-ip=198.18.0.0-198.19.255.255
              denied-peer-ip=198.51.100.0-198.51.100.255
              denied-peer-ip=203.0.113.0-203.0.113.255
              denied-peer-ip=240.0.0.0-255.255.255.255
              denied-peer-ip=::1
              denied-peer-ip=64:ff9b::-64:ff9b::ffff:ffff
              denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
              denied-peer-ip=100::-100::ffff:ffff:ffff:ffff
              denied-peer-ip=2001::-2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff
              denied-peer-ip=2002::-2002:ffff:ffff:ffff:ffff:ffff:ffff:ffff
              denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
              denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff
            '';
          };
          # open the firewall
          networking.firewall = {
            interfaces.${networkInterface} = let
              range = with config.services.coturn;
                lib.singleton {
                  from = min-port;
                  to = max-port;
                };
            in {
              allowedUDPPortRanges = range;
              allowedUDPPorts = [3478 5349];
              allowedTCPPortRanges = [];
              allowedTCPPorts = [3478 5349];
            };
          };
          # get a certificate
          security.acme.certs.${config.services.coturn.realm} = {
            webroot = "/var/lib/acme/acme-challenge/";
            email = "www.tias.dev@gmail.com";
            postRun = "systemctl restart coturn.service";
          };
          services.nginx.virtualHosts.${config.services.coturn.realm} = {
            enableACME = true;
            acmeRoot = "/var/lib/acme/acme-challenge/";
          };
          # configure synapse to point users to coturn
          services.matrix-synapse.settings = with config.services.coturn; {
            turn_uris = ["turn:${realm}:3478?transport=udp" "turn:${realm}:3478?transport=tcp"];
            turn_user_lifetime = "1h";
          };
        })
      ];
    };
  };
}
