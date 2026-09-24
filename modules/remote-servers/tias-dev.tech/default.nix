{config, ...}: let
  config' = config;
  hostname = "tias-dev-tech";
  domain = "tias-dev.tech";
  email = "www.tias.dev@gmail.com";
  inherit
    (config.flake.lib)
    mkStaticNetworkAddressModule
    mkForgejoModule
    collectNixosModules
    mkMonitoringModule
    mkGrafanaNtfyForwarder
    mkMatrixServer
    mkNtfyService
    ;

  nixosModules = [
    "user"
    "sops"
    "docker"
    "nginx"
    "postgresql"
  ];
in {
  flake = {
    nixosConfigurations.${domain} = config.flake.lib.mkRemoteServer {
      inherit hostname domain;
      username = "tias-dev";
    };
    modules.nixos."hosts/${domain}" = {config, ...}: {
      disko.devices.disk.disk1.device = "/dev/sda";
      imports =
        [
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
        ]
        ++ (collectNixosModules config' nixosModules);
      security.acme.acceptTerms = true;
      security.acme.defaults.email = email;
      networking.firewall.allowedTCPPorts = [80 443];
    };
  };
}
