{config, ...}: let
  inherit (config.flake.meta) xray-assets-path;
  inherit (config.flake.lib) mkXrayConfigGenerator;
  inherit (config.flake.modules.nixos) xray-update-blocklists;
in {
  config = {
    flake = {
      lib = {
        mkXrayService = {
          domain,
          mode,
          baseConfig,
          clientsConfig ? "",
          nextPeerConfig ? "",
          fallbackNginxPort ? 8080,
          dummyNginxSslPort ? 8443,
        }: {
          config,
          pkgs,
          lib,
          ...
        }: let
          merged-config = "/etc/xray/xray.json";
        in {
          config = {
            assertions = [
              {
                assertion = mode == "peer" || mode == "endpoint";
                message = "In server xray config mode must be set to 'peer' or 'endpoint'";
              }
              {
                assertion = (mode == "peer" && clientsConfig != "" && nextPeerConfig != "") || (mode != "peer");
                message = "For mode 'peer' clientsConfig and nextPeerConfig must be set";
              }
              {
                assertion = (mode == "endpoint" && clientsConfig != "") || (mode != "endpoint");
                message = "For mode 'endpoint' clientsConfig must be set";
              }
            ];

            services.xray = {
              enable = true;
              settingsFile = merged-config;
            };

            # ensure xray user in nginx group in order to be able to use nginx owned certificates
            users.users.xray = {
              isSystemUser = true;
              group = "xray";
              extraGroups = ["nginx"];
            };
            users.groups.xray = {};

            systemd.services.xray = {
              environment = {XRAY_LOCATION_ASSSET = xray-assets-path;};
              # ensure folder xray logs exists
              serviceConfig = {
                LogsDirectory = "xray";
                LogsDirectoryMode = "0750";
              };
            };

            # generate xray config before xray start
            systemd.services.xray-config-gen = let
              config-merger = mkXrayConfigGenerator {
                pkgs = pkgs;
                fallbackNginxPort = fallbackNginxPort;
              };
              certs-dir = config.security.acme.certs.${domain}.directory;
            in {
              description = "Generate Xray configuration";
              wantedBy = ["xray.service"];
              before = ["xray.service"];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };
              script =
                /*
                bash
                */
                ''
                  set -xeuo pipefail
                  mkdir -p $(dirname ${merged-config})
                  args=(${mode} ${baseConfig} --cert_file ${certs-dir}/cert.pem --key_file ${certs-dir}/key.pem)

                  case "${mode}" in
                    peer)
                      args=(''${args[@]} --clients_config ${clientsConfig} --next_peer_config ${nextPeerConfig})
                      ;;
                    endpoint)
                      args=(''${args[@]} --clients_config ${clientsConfig})
                      ;;
                    *)
                      echo "Undefinded mode: ${mode}. Expected 'peer' or 'endpoint'"
                      exit 1
                  esac

                  ${lib.getExe config-merger} ''${args[@]} > ${merged-config}
                '';
            };

            # override ssl port due to xray uses 443 port and fallbacks unauthorized users to nginx at fallbackNginxPort
            services.nginx = {
              defaultSSLListenPort = lib.mkForce dummyNginxSslPort;
              virtualHosts = {
                "${domain}" = {
                  listen = [
                    {
                      addr = "0.0.0.0";
                      port = 80;
                      ssl = false;
                    }
                    {
                      addr = "[::0]";
                      port = 80;
                      ssl = false;
                    }
                    {
                      addr = "127.0.0.1";
                      port = dummyNginxSslPort;
                      ssl = true;
                    } # dummy ssl port for acme certs renew
                  ];
                };
                "://${domain}" = {
                  serverName = domain;
                  locations = config.services.nginx.virtualHosts.${domain}.locations;
                  listen = [
                    {
                      addr = "127.0.0.1"; # fallback ipv4 port
                      port = fallbackNginxPort;
                      ssl = false;
                    }
                    {
                      addr = "[::1]"; # fallback ipv6 port
                      port = fallbackNginxPort;
                      ssl = false;
                    }
                  ];
                };
              };
            };

            xray-update-blocklists = {
              enable = lib.mkDefault true;
              proxy.enable = lib.mkDefault true;
            };
          };
          # auto-import xray blocklists updater
          imports = [
            xray-update-blocklists
          ];
        };
      };
    };
  };
}
