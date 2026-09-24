{
  self,
  inputs,
  ...
}: let
  inherit (inputs) deploy-rs;
  system = "x86_64-linux"; # For default linux only now
in {
  config.flake = {
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    deploy = {
      nodes = {
        "tias-dev.tech" = rec {
          hostname = "tias-dev.tech";
          profiles.system = {
            user = "root";
            sshUser = "root";
            path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${hostname};
          };
        };
      };
    };

    # deploy utility
    modules.homeManager.deploy = {system, ...}: {
      home.packages = [inputs.deploy-rs.packages.${system}.default];
    };
  };
}
