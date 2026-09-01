{config, ...}: let
  hostname = "tias-dev-tech";
  inherit
    (config.flake.lib)
    mkStaticNetworkAddressModule
    mkForgejoModule
    collectNixosModules
    mkMonitoringModule
    mkMatrixServer
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
    nixosConfigurations.${hostname} = config.flake.lib.mkRemoteServer {
      inherit hostname;
      username = "tias-dev";
      domain = "tias-dev.tech";
    };
    modules.nixos."hosts/${hostname}" = {
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
            email = "www.tias.dev@gmail.com";
          })
          (mkMonitoringModule {
            domain = "monitoring.tias-dev.tech";
            adminEmail = "www.tias.dev@gmail.com";
          })
          (mkMatrixServer {
            subdomain = "matrix";
          })
        ]
        ++ (collectNixosModules config nixosModules);
      security.acme.acceptTerms = true;
      networking.firewall.allowedTCPPorts = [80 443];
    };
  };
}
