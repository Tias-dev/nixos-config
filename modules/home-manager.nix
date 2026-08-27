{lib, ...}: {
  options.flake = {
    homeConfigurations = lib.mkOption {
      default = {};
      type = lib.types.lazyAttrsOf lib.types.raw;
    };
  };

  config.flake.modules.nixos.nixos = {
    home-manager.backupFileExtension = ".bak";
  };

  config.flake.modules.homeManager.homeManager = {
    nixpkgs.config.allowUnfree = true;
  };
}
