{
  config,
  lib,
  configurations-lib,
  ...
}: let
  hostname = "repo-tias-dev-tech";
  domain = "repo.tias-dev.tech";
  email = "www.tias.dev@gmail.ru";
  inherit
    (config.flake.lib)
    mkStaticNetworkAddressModule
    mkForgejoModule;

  nixosModules = [
    "user"
    "sops"
    "nginx"
  ];
in {
  config = lib.mkMerge [
    ((configurations-lib.mkSystems config).remoteLinux
      {
        inherit hostname domain;
        username = "tias-dev";
        modules = nixosModules;
        defaultAdminTools = false;
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
              address = "130.49.172.25";
              gateway = "130.49.172.1";
              interface = "enp1s0";
            })
            (mkForgejoModule {
              domain = "repo.tias-dev.tech";
              disableRegistration = true;
              addDefaultRunner = false;
              opensshPort = 10100;
            })
          ];
          security.acme.acceptTerms = true;
          security.acme.defaults.email = email;
          networking.firewall.allowedTCPPorts = [80 443];
        };
      })
  ];
}
