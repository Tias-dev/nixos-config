{
  config.flake.modules.homeManager.niri = {lib, ...}: {
    options = {
      desktop.custom-lock-cmd = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Custom screen lock command to use in niri bindings";
      };
    };
  };
}
