{
  flake.modules.nixos.desktop = {
    lib,
    config,
    username,
    ...
  }: {
    options = {
      tui-greeter.enable = lib.mkEnableOption "tui greeter(no graphics)";
      active-display-manager = lib.mkOption {
        type = lib.types.str;
      };
    };
    config = {
      tui-greeter.enable = lib.mkDefault true;
      services.displayManager = {
        ly = lib.mkIf config.tui-greeter.enable {
          enable = true;
        };
      };
      users.users.${username}.extraGroups = lib.mkIf (!config.tui-greeter.enable) ["greeter"];
    };
  };
}
