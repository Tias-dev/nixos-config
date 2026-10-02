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
    homeConfigurations."server-hm-only-minimal" = config.flake.lib.mkSystems.linuxHMOnly "server-hm-only-minimal" {username = "root";};
    modules.homeManager."hosts/server-hm-only-minimal" = {
      imports = config.flake.lib.collectHomeModules config modules;
      tmux.server-copy-command.enable = true;
    };
  };
}
