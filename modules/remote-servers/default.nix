{
  inputs,
  config,
  lib,
  ...
}: {
  config.flake.lib = {
    mkRemoteServer = hostname: let
      system = "x86_64-linux";
    in
      inputs.nixpkgs.lib.nixosSystem rec {
        inherit system;
        modules = [
          inputs.disko.nixosModules.disko
          {
            config._module.args = {
              inherit hostname system;
              username = "default";
            };
          }
          config.flake.modules.nixos.remote-servers
          (config.flake.modules.nixos."hosts/${hostname}" or {})
          {
            networking.hostName = hostname;
            nixpkgs.hostPlatform = system;
            system.stateVersion = "25.11";
          }
        ];
      };
  };
}
