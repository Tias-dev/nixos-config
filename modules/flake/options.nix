{lib, ...}: {
  options.flake = {
    lib = lib.mkOption {
      default = {};
      type = lib.types.lazyAttrsOf lib.types.raw;
    };
  };
}
