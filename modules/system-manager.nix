{lib, ...}: {
  options.flake = {
    systemConfigs = lib.mkOption {
      default = {};
      type = lib.types.lazyAttrsOf lib.types.raw;
    };
  };
  config.flake.modules.systemManager.systemManager = {
    lib,
    system,
    ...
  }: {
    config = {
      nixpkgs.hostPlatform = system;
    };
    options = {
      security.dhparams = lib.mkOption {
        type = lib.types.raw;
      };
    };
  };
}
