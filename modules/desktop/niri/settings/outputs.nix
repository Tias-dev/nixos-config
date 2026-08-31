{config, ...}: let
  inherit (config.flake.desktop) secondary-monitors;
in {
  flake.modules.homeManager.niri = {
    config,
    lib,
    ...
  }: let
    primary-monitor-config = {
      scale = 1.2;
      focus-at-startup = true;
      position = {
        x = 0;
        y = 0;
      };
    };
    secondary-monitor-config = {
      scale = 1;
      focus-at-startup = false;
      position = {
        y = 0;
      };
    };
    inherit (config.desktop) primary-monitor;
  in {
    niri-settings.outputs =
      {
        "${primary-monitor.name}" = primary-monitor-config // {inherit (primary-monitor) mode;} // (primary-monitor.extraNiriSettings or {});
      }
      // (lib.lists.foldl' (acc: monitor: {
          width = acc.width + monitor.mode.width;
          config =
            acc.config
            // {
              "${monitor.name}" = secondary-monitor-config // {inherit (monitor) mode;} // (monitor.extraNiriSettings or {}) // {position.x = acc.width;};
            };
        })
        {
          width = primary-monitor.mode.width;
          config = {};
        }
        secondary-monitors).config;
  };
}
