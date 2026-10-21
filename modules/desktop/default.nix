{inputs, ...}: {
  config.flake.modules.homeManager.desktop = {
    lib,
    ...
  }: {
      options.primary-wm = lib.mkOption {
        type = lib.types.str;
      };
  };
}
