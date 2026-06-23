{config, ...}: let
  modules = [
    "ownProxy"
    "desktop"
    "niri"
    "bluetooth"

    "develop"
    "neovim"
    "zsh"
    "alacritty"
    "tmux"
    "docker"

    "browser"
  ];
in {
  flake = {
    homeConfigurations.raison = config.flake.lib.mkSystems.linuxHMOnly "archer";
    modules.homeManager."hosts/archer" = {
      imports = (config.flake.lib.collectHomeModules config modules);
    };

    systemConfigs.default = config.flake.lib.mkSystems.linuxSMOnly "archer";
  };
}
