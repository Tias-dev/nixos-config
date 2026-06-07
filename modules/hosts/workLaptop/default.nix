{config, ...}: let
  modules = [
    "efiBoot"
    "tabuchkin"
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
    "documents"
  ];
in {
  flake = {
    nixosConfigurations.tabuchkin = config.flake.lib.mkSystems.linux "tabuchkin-nix" "tabuchkin";
    modules.nixos."hosts/tabuchkin-nix" = {
      imports =
        config.flake.lib.collectModules config modules;
    };
  };
}

