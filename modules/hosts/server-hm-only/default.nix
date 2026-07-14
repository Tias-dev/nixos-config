{config, ...}: let
  modules = [
    "develop"
    "neovim"
    "zsh"
    "tmux"
    "arc"
  ];
in {
  flake = {
    homeConfigurations."sdg-robot-bl-vla.vla.yp-c.yandex.net" = config.flake.lib.mkSystems.linuxHMOnly "sdg-robot-bl-vla.vla.yp-c.yandex.net" {username = "tabuchkin";};
    modules.homeManager."hosts/sdg-robot-bl-vla.vla.yp-c.yandex.net" = {
      imports = config.flake.lib.collectHomeModules config modules;
      tmux.server-copy.command.enable = true;
    };
  };
}
