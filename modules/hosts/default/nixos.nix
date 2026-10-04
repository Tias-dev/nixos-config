{
  config.flake.modules.nixos.nixos = {
    system,
    hostname,
    lib,
    home-manager-enabled,
    ...
  }: {
    # nixos
    nixpkgs.config.allowUnfree = true;
    networking = {
      hostName = lib.mkDefault hostname;
    };
    nixpkgs.hostPlatform = system;
    system.stateVersion = "25.11";

    # home-manager
    home-manager = lib.mkIf home-manager-enabled {
      backupFileExtension = ".bak";
    };
  };
}
