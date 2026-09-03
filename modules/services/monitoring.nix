# services: prometheus + grafana
{
  config.flake.lib = {
    mkMonitoringModule = {
      domain,
      useNginx ? true,
      extraCollectors ? [],
      exporterPort ? 9000,
      prometheusPort ? 9090,
      grafanaPort ? 3001,
      adminEmail ? null,
    }: {
      config,
      lib,
      ...
    }: {
      # prometheus
      services.prometheus = {
        enable = true;
        port = prometheusPort;
        globalConfig = {
          scrape_interval = "15s";
          scrape_timeout = "12s"; # close to scrape interval to preserve dropping
        };
        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
              }
            ];
          }
        ];
      };
      # exporter
      services.prometheus.exporters.node = {
        enable = true;
        port = exporterPort;
        enabledCollectors =
          [
            "ethtool"
            "diskstats"
            "systemd"
            "tcpstat"
            "processes"
          ]
          ++ extraCollectors;
      };

      # grafana
      services.grafana = {
        enable = true;
        settings = {
          server = {
            http_addr = "127.0.0.1";
            http_port = grafanaPort;
            enforce_domain = true;
            enable_gzip = true;
            domain = domain;
          };
          security = {
            admin_user = "Tias";
            admin_email = lib.mkIf (adminEmail != null) adminEmail;
            admin_password = "$__file{${config.sops.secrets.grafana-admin-password.path}}";
            secret_key = "$__file{${config.sops.secrets.grafana-secret-key.path}}";
          };
        };
        provision = {
          enable = true;
          datasources.settings.datasources = [
            # Prometheus data source
            {
              name = "Prometheus";
              type = "prometheus";
              url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
              isDefault = true;
              editable = false;
            }
          ];
        };
      };

      sops.secrets = {
        grafana-admin-password = {
          sopsFile = ../../secrets/grafana/secrets.yaml;
          format = "yaml";
          key = "admin_password";
          owner = "grafana";
        };
        grafana-secret-key = {
          sopsFile = ../../secrets/grafana/secrets.yaml;
          format = "yaml";
          key = "secret_key";
          owner = "grafana";
        };
      };

      # nginx
      services.nginx = lib.mkIf useNginx {
        virtualHosts.${domain} = {
          forceSSL = true;
          enableACME = true;
          locations."/" = let
            inherit (config.services.grafana.settings.server) http_addr http_port;
          in {
            proxyPass = "http://${http_addr}:${toString http_port}";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
