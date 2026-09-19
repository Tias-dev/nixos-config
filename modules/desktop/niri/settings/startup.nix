{config, ...}: let
  inherit (config.flake.meta) terminal;
in {
  config.flake.modules.homeManager.niri = {lib, config, ...}: {
    niri-settings = {
      spawn-at-startup = [
        {argv = ["${lib.getExe config.browser.package}"];}
        {
          argv = [terminal.path];
        }
      ];
      hotkey-overlay.skip-at-startup = true;
    };
  };
}
