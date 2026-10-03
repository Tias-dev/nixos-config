{config, ...}: let
  hostname = "generic";
  inherit (config.flake.lib) mkRemoteServer;
in {
  flake = {
    nixosConfigurations.${hostname} = mkRemoteServer {inherit hostname;};
    modules.nixos."hosts/${hostname}" = {username, ...}: {
      disko.devices.disk.disk1.device = "/dev/sda";
      home-manager.users.${username}.imports = [
        {
          home = {
            stateVersion = "26.05";
          };
        }
      ];
    };
  };
}
