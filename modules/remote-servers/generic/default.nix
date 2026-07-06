{config, ...}: let
  hostname = "generic";
in {
  flake = {
    nixosConfigurations.${hostname} = config.flake.lib.mkRemoteServer hostname;
  };
}
