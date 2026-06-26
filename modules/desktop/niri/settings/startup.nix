{config, ...}: let
  inherit (config.flake.meta) terminal;
in {
  flake.modules.generic.niri.settings = {
    spawn-at-startup = [
      {argv = ["firefox"];}
      {
        argv = [terminal.path];
      }
    ];
    hotkey-overlay.skip-at-startup = true;
  };
}
