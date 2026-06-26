{config, ...}: let
  modules = [
    "develop"
    "neovim"
    "zsh"
    "tmux"
  ];
in {
  flake = {
    homeConfigurations.tabuchkin = config.flake.lib.mkSystems.linuxHMOnly "tabuchkin-nix" {username = "tabuchkin";};
    modules.homeManager."hosts/tabuchkin-nix" = {
      imports = config.flake.lib.collectHomeModules config modules;
    };
  };
}
