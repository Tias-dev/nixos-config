{config, ...}: let
  modules = [
    "efiBoot"
    "desktop"
    "niri"
    "kitty"
    "terminal"
    "ownProxy"
    "tmux"
    "develop"
    "browser"
    "docker"
    "recording"
    "torrent"
    "documents"
  ];
in {
  flake = {
    nixosConfigurations.laptop-raison = config.flake.lib.mkSystems.linux "laptop-raison";
    modules.nixos."hosts/laptop-raison" = {
      imports =
	(config.flake.lib.collectModules config modules);
    };
  };
}
