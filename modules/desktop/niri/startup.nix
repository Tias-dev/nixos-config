{
  flake.modules.homeModules.niri = {config, ...}: {
    spawn-at-startup = [
      {argv = ["firefox"];}
      {
        argv = ["kitty"]; # [config.terminal.path];
      }
    ];
  };
}
