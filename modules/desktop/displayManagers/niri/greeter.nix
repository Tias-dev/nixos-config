{
  config.flake.modules.nixos.niri = {lib, config, ...}: {
    tui-greeter.enable = false;

    services.displayManager = {
      dms-greeter = lib.mkIf (config.programs.niri.enable) {
        enable = true;
        compositor.name = "niri";
      };
    };
  };
}
