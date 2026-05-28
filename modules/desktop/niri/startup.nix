{config, ...}: {
  flake.modules.homeModules.niri.startup = [
    {argv = ["firefox"];}
    {
      argv = [config.terminal.path];
    }
  ];
}
