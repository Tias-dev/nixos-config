{
  config.flake.modules.systemManager.systemManager = {
    lib,
    system,
    ...
  }: {
    config = {
      nixpkgs.hostPlatform = system;
    };

    # thumbs for nixos compatibility
    options = {
      security.dhparams = lib.mkOption {
        type = lib.types.raw;
      };
    };
  };
}
