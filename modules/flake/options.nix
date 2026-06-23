{ lib, ... }:
{
  options.flake.homeConfigurations = lib.mkOption {
    default = {};
    type = lib.types.lazyAttrsOf lib.types.raw;
  };
}
