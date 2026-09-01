{config, ...}: let
  hostname = "tias-dev-tech";
  inherit (config.flake.lib) mkStaticNetworkAddressModule mkForgejoModule collectNixosModules mkMonitoringModule;
  nixosModules = [
    "sops"
    "docker"
  ];
in {
  flake = {
    nixosConfigurations.${hostname} = config.flake.lib.mkRemoteServer {
      inherit hostname;
      username = "forgejo";
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
        ]
        ++ (collectNixosModules config nixosModules);
      services.nginx = {
        enable = true;
      };
      security.acme.acceptTerms = true;
      networking.firewall.allowedTCPPorts = [22 80 443];

      sops-home-path = "/var/lib";
    };
  };
}
