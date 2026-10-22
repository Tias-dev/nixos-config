{
  flake.modules.nixos.desktop = {
    lib,
    config,
    username,
    ...
  }: {
    options = {
      custom-greeter = lib.mkEnableOption "Custom greeter to use(use ly gretter if false)";
      active-display-manager = lib.mkOption {
        type = lib.types.str;
      };
    };
    config = {
      services.displayManager = {
        ly = lib.mkIf (!config.custom-greeter) {
          enable = true;
        };
      };
      users.users.${username}.extraGroups = lib.mkIf (config.custom-greeter) ["greeter"];
    };
  };
}
