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
              {
                assertion = lib.hasAttr domain config.services.nginx.virtualHosts;
                message = "${domain} nginx virtual host must be set as xray fallback";
              }
            ];

            services.xray = {
              enable = true;
              settingsFile = merged-config;
            };

            # ensure xray user in nginx group in order to be able to use nginx owned certificates
            # ensure xray user in acme group in order to be able to use acme issued certs
            users.users.xray = {
              isSystemUser = true;
              group = "xray";
              extraGroups = ["nginx" "acme"];
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
              after = ["acme-${domain}.service"];
              wants = ["acme-${domain}.service"];
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

            # Setup nginx
            # 1. Ensure cert for 'domain' exists
            # 2. Force to use only 1 cert from given 'domain' to verify all placed sites
            # 3. Setup all vhosts to listen at 'fallbackNginxPort' port as tls fallback from xray
            # 4. For all vhosts add paired vhost at 80  port for acme-challenges + redirecting to https

            # ensure cert
            security.acme.certs.${domain} = {
              extraDomainNames = lib.mkForce (lib.filter (vhostDomain: vhostDomain != domain && !(lib.hasPrefix "://" vhostDomain)) (lib.attrNames config.services.nginx.virtualHosts));
              webroot = "/var/lib/acme/acme-challenge";
              reloadServices = ["xray.service"];
            };

            services.nginx = let
              originalVHostsNames = config.nginx-vhosts;
            in {
              # For all vhosts add paired vhost which will listen at 80 port, verifies acme certs and redirects to https xray port(443)
              # xray will fallback to original service after tls connection is set
              virtualHosts =
                lib.genAttrs
                (map (name: "://${name}") originalVHostsNames)
                (pairedName: let
                  origName = lib.removePrefix "://" pairedName;
                in {
                  serverName = origName;
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
                  ];
                  locations = {
                    "/.well-known/acme-challenge" = {
                      root = config.security.acme.certs.${domain}.webroot;
                    };
                    "/" = {
                      return = "301 https://$host$request_uri";
                    };
                  };
                });
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

          options = {
            # Setup all vhosts to listen at 80 port for acme-challenges + redirecting to https
            services.nginx.virtualHosts = lib.mkOption {
              type = lib.types.attrsOf (lib.types.submodule ({
                config,
                name,
                ...
              }: {
                config = lib.mkIf (!lib.hasPrefix "://" name) {
                  # override only plain vhosts not extended pairs
                  # remove auto SSL and set listen ports to xray fallbacks
                  forceSSL = lib.mkForce false;
                  addSSL = lib.mkForce false;
                  enableACME = lib.mkForce false;

                  listen = lib.mkForce [
                    {
                      addr = "127.0.0.1"; # ipv4
                      port = fallbackNginxPort;
                      ssl = false;
                    } # used for acme challenge
                    {
                      addr = "[::1]"; # ipv6
                      port = fallbackNginxPort;
                      ssl = false;
                    }
                  ];
                  # don't touch proxyPass locations
                };
              }));
            };
          };
        };
      };
    };
  };
}
