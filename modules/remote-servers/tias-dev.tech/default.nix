{
  config,
  lib,
  configurations-lib,
  ...
}: let
  hostname = "tias-dev-tech";
  domain = "tias-dev.tech";
  email = "www.tias.dev@gmail.com";
  inherit
    (config.flake.lib)
    mkStaticNetworkAddressModule
    mkForgejoModule
    collectModules
    mkMonitoringModule
    mkGrafanaNtfyForwarder
    mkMatrixServer
    mkNtfyService
    mkPostgRESTModule
    ;

  nixosModules = [
    "user"
    "sops"
    "docker"
    "nginx"
    "postgresql"
  ];
in {
  config = lib.mkMerge [
    (configurations-lib.mkSystems.remoteLinux
      {
        inherit hostname domain;
        username = "tias-dev";
        modules = nixosModules;
      })
    (configurations-lib.personalRemoteNixosModule
      {
        inherit hostname domain;
        module = {
          disko.devices.disk.disk1.device = "/dev/sda";
          imports = [
            (mkStaticNetworkAddressModule {
              address = "178.208.81.239";
              gateway = "178.208.81.2";
              interface = "enp1s0";
            })
            (mkForgejoModule {
              domain = "git.tias-dev.tech";
              disableRegistration = true;
              addDefaultRunner = true;
              email = email;
            })
            (mkMatrixServer {
              subdomain = "matrix";
            })
            (mkMonitoringModule {
              domain = "monitoring.tias-dev.tech";
              adminEmail = email;
            })
            (mkGrafanaNtfyForwarder {
              ntfyFqdn = "ntfy.${config.networking.domain}";
              ntfyTopic = "notify-grafana";
            })
            (mkNtfyService {})
            (mkPostgRESTModule {
              port = 3007;
              extraSqlInitScriptPath = ./postgresql-init-script.sql;
            })
          ];
          security.acme.acceptTerms = true;
          security.acme.defaults.email = email;
          networking.firewall.allowedTCPPorts = [80 443];
        };
      })
  ];
}
