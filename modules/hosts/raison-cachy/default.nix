{config, ...}: let
  modules = [
    "desktop"
    "niri"
    "bluetooth"
    "swaylock"

    "develop"
    "zsh"
    "neovim"
    "kitty"
    "tmux"
    "browser"
  ];
in {
  flake = {
    homeConfigurations."raison-cachy" = config.flake.lib.mkSystems.linuxHMOnly "raison-cachy" {username = "raison";};
    modules.homeManager."hosts/raison-cachy" = {
      imports = config.flake.lib.collectHomeModules config modules;
    };
  };
}
