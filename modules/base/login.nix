{
  flake.modules.nixos.desktop = {
    lib,
    config,
    ...
  }: {
    options = {
      tui-greeter.enable = lib.mkEnableOption "tui greeter(no graphics)";
    };
    config = {
      services.displayManager = {
        ly = lib.mkIf config.tui-greeter.enable {
          enable = true;
        };
        dms-greeter = lib.mkIf (!config.tui-greeter.enable) {
          enable = true;
          compositor.name = "niri";
        };
      };
    };
  };
}
