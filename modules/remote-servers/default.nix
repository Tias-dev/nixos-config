{
  inputs,
  config,
  lib,
  ...
}: {
  config.flake.lib = {
    mkStaticNetworkAddressModule = {
      address,
      gateway,
      interface,
      prefixLength ? 24,
    }: {
      networking.interfaces.${interface}.ipv4.addresses = [
        {
          inherit address prefixLength;
        }
      ];
      networking.defaultGateway = gateway;
    };
    mkRemoteServer = {
      hostname,
      username ? "default",
      domain ? null,
    }: let
      system = "x86_64-linux";
      server-name =
        if domain != null
        then domain
        else hostname;
    in
      inputs.nixpkgs.lib.nixosSystem rec {
        inherit system;
        modules = [
          inputs.disko.nixosModules.disko
          inputs.home-manager.nixosModules.home-manager
          {
            config = {
              _module.args = {
                inherit hostname system username;
              };
              home-manager.users.${username}.imports = [
                {config._module.args = {inherit username system;};}
                (config.flake.modules.homeManager."hosts/${hostname}" or {})
              ];
            };
          }
          config.flake.modules.nixos.remote-servers
          (config.flake.modules.nixos."hosts/${server-name}" or {})
          {
            nixpkgs.config.allowUnfree = true;
            networking.hostName = hostname;
            networking.domain = domain;
            networking.firewall.allowedTCPPorts = [22];
            nixpkgs.hostPlatform = system;
            system.stateVersion = "25.11";
          }
        ];
      };
  };
}
