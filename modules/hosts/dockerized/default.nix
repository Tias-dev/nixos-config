{config, ...}: let
  modules = [
    "develop"
    "neovim"
    "zsh"
    "tmux"
  ];
in {
  flake = {
    nixosConfigurations.dockerized = config.flake.lib.mkSystems.linux "laptop-raison" "raison";
    modules.nixos."hosts/dockerized" = {
      imports =
        config.flake.lib.collectModules config modules "raison";
    };
  };
}
