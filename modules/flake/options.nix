{lib, ...}: {
  options.flake = {
    lib = lib.mkOption {
      default = {};
      type = lib.types.lazyAttrsOf lib.types.raw;
    };

    homeConfigurations = lib.mkOption {
      default = {};
      type = lib.types.lazyAttrsOf lib.types.raw;
    };

    systemConfigs = lib.mkOption {
      default = {};
      type = lib.types.lazyAttrsOf lib.types.raw;
    };
  };
}
