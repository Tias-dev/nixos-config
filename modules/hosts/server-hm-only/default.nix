{config, ...}: let
  modules = [
    "develop"
    "zsh"
    "tmux"
  ];
in {
  flake = {
    homeConfigurations.server-hm-only = config.flake.lib.mkSystems.linuxHMOnly "sdg-robot-bl-vla" {username = "tabuchkin";};
    modules.homeManager."hosts/sdg-robot-bl-vla" = {
      imports = config.flake.lib.collectHomeModules config modules;
    };
  };
}
