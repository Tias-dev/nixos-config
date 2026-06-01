{config, ...}: let
  modules = [
    "efiBoot"
    "ownProxy"
    "desktop"
    "niri"
    "bluetooth"

    "develop"
    "zsh"
    "kitty"
    "tmux"
    "docker"

    "browser"
    "recording"
    "torrent"
    "documents"
  ];
in {
  flake = {
    nixosConfigurations.laptop-raison = config.flake.lib.mkSystems.linux "laptop-raison";
    modules.nixos."hosts/laptop-raison" = {
      imports =
        config.flake.lib.collectModules config modules;
    };
  };
}
