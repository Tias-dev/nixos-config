{
  inputs,
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
    mkMonitoringModule
    mkGrafanaNtfyForwarder
    mkMatrixServer
    mkNtfyService
    mkPostgRESTModule
    mkRadicaleService
    mkWebDavService
    mkTailscaleService
    ;

  nixosModules = [
    "user"
    "sops"
    "docker"
    "nginx"
    "postgresql"
  ];
  mkSimpleSiteFromPkg = package: {config, ...}: {
    services.nginx.virtualHosts = {
      "${package.name}.${config.networking.domain}" = {
        forceSSL = true;
        enableACME = true;
        root = "${package}";
      };
    };
  };
in {
  config = lib.mkMerge [
    ((configurations-lib.mkSystems config).remoteLinux
      {
        inherit hostname domain;
        username = "tias-dev";
        modules = nixosModules;
      })
    (configurations-lib.personalRemoteNixosModule
      {
        inherit hostname domain;
        module = {
          config,
          system,
          ...
        }: {
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
              extraRunnerHostPackages = with inputs.tias-nixpkgs.packages.${system}; [
                ost-toolkit
              ];
              opensshPort = 10100;
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
            (mkRadicaleService {})
            (mkWebDavService {})
            (mkTailscaleService {})
            {
              services.postgresql.enableTCPIP = true; # for connect over tailscale
              services.postgresql.authentication = "host postgres authenticator 100.123.204.121/32 password";
            }
            (mkSimpleSiteFromPkg inputs.tias-nixpkgs.packages.${system}.frontend-labs_simple-site)
          ];
          security.acme.acceptTerms = true;
          security.acme.defaults.email = email;
          networking.firewall.allowedTCPPorts = [80 443];
        };
      })
  ];
}
