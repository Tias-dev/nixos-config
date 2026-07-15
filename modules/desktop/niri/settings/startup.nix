{config, ...}: let
  inherit (config.flake.meta) terminal;
in {
  config.flake.modules.homeManager.niri.niri-settings = {
    spawn-at-startup = [
      {argv = ["firefox"];}
      {
        argv = [terminal.path];
      }
    ];
    hotkey-overlay.skip-at-startup = true;
  };
}
