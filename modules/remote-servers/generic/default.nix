{config, ...}: let
  hostname = "generic";
in {
  flake = {
    nixosConfigurations.${hostname} = config.flake.lib.mkRemoteServer hostname;
    modules.nixos."hosts/${hostname}" = {
      disko.devices.disk.disk1.device = "/dev/sda";
    };
  };
}
