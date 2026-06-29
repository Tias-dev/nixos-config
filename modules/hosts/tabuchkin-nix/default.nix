{config, ...}: let
  modules = [
    "desktop"
    "niri"
    "bluetooth"

    "develop"
    "zsh"
    "kitty"
    "tmux"
    "docker"

    "browser"
  ];
in {
  flake = {
    homeConfigurations.tabuchkin-nix = config.flake.lib.mkSystems.linuxHMOnly "tabuchkin-nix" {username = "tabuchkin";};
    modules.homeManager."hosts/tabuchkin-nix" = {
      imports = (config.flake.lib.collectHomeModules config modules);
    };

    systemConfigs.default = config.flake.lib.mkSystems.linuxSMOnly "tabuchkin-nix";
  };
}
