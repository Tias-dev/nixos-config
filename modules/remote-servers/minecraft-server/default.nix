{config, ...}: let
  hostname = "minecraft-server";
  modules = [
    "minecraft-server"
  ];
in {
  flake = {
    # first run to install nixos on any server
    # nix run github:nix-community/nixos-anywhere -- --flake .#minecraft-server --generate-hardware-config nixos-generate-config ./modules/remote-servers/_generic/hardware-configuration.nix root@<hostname>

    # second run to just update nixos configuration if need
    # nixos-rebuild switch --flake .#minecraft-server --target-host root@51.250.27.192 --build-host root@51.250.27.192
    nixosConfigurations.${hostname} = config.flake.lib.mkRemoteServer hostname;
    modules.nixos."hosts/${hostname}" = {
      imports = config.flake.lib.collectNixosModules config modules;
    };
  };
}
