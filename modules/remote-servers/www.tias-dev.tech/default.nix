{config, ...}: let
  hostname = "www-tias-dev-tech";
  inherit (config.flake.lib) mkStaticNetworkAddressModule mkForgejoModule;
in {
  flake = {
    nixosConfigurations.${hostname} = config.flake.lib.mkRemoteServer hostname;
    modules.nixos."hosts/${hostname}" = {
      disko.devices.disk.disk1.device = "/dev/sda";
      imports = [
        (mkStaticNetworkAddressModule {
          address = "178.208.81.239";
          gateway = "178.208.81.2";
          interface = "enp1s0";
        })
        (mkForgejoModule {
          domain = "www.tias-dev.tech";
          enableRegistration = false;
        })
      ];
      services.nginx = {
        enable = true;
      };
      security.acme.acceptTerms = true;
      networking.firewall.allowedTCPPorts = [22 80 443];
    };
  };
}
