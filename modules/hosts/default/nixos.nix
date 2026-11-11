{
  config.flake.modules.nixos = {
    nixos = {
      system,
      hostname,
      lib,
      ...
    }: {
      # nixos
      nixpkgs.config.allowUnfree = true;
      networking = {
        hostName = lib.mkDefault hostname;
      };
      nixpkgs.hostPlatform = system;
      system.stateVersion = "25.11";
    };
    homeManager = {
      # home-manager
      home-manager = {
        backupFileExtension = ".bak";
      };
    };
  };
}
