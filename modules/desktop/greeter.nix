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
      services.displayManager = {
        ly = lib.mkIf (!config.programs.niri.enable) {
          enable = true;
        };
        dms-greeter = lib.mkIf (config.programs.niri.enable) {
          enable = true;
          compositor.name = "niri";
        };
      };
      users.users.${username}.extraGroups = lib.mkIf (!config.tui-greeter.enable) ["greeter"];
    };
  };
}
